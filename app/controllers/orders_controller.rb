#encoding: utf-8

class OrdersController < ApplicationController
  before_filter :authenticate_user
  before_filter :get_user

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(params[:order])
    @order.so = SecureRandom.hex
    @order.user_id = @user.id
    @order.email = @user.email unless @user.is_guest?

    if @user.is_guest?
      #error_stickie t("message.email_existed") if User.find_by_email(order.email)
      if User.find_by_email(@order.email)
        render :new
        return
      end
    end

    if @order.save
      pay(@order)
    else
      #error_stickie t("message.validate_email")
      render :new
    end
  end

  # 支付宝
  def success

    AlipayLog.create(
        :body => params[:body],
        :buyer_email =>  params[:buyer_email],
        :buyer_id  =>  params[:buyer_id],
        :exterface =>  params[:exterface],
        :is_success =>  params[:is_success],
        :notify_id  =>  params[:notify_id],
        :notify_time =>  params[:notify_time],
        :notify_type =>  params[:notify_type],
        :out_trade_no =>  params[:out_trade_no],
        :payment_type =>  params[:payment_type],
        :seller_email => params[:seller_email],
        :seller_id  =>  params[:seller_id],
        :subject =>  params[:subject],
        :total_fee =>  params[:total_fee],
        :trade_no  =>  params[:trade_no],
        :trade_status =>  params[:trade_status],
        :sign =>  params[:sign],
        :sign_type =>  params[:sign_type]
    )


    order = Order.find_by_so(params['out_trade_no'])
    order.update_attribute(:status, 'success')

    find_and_login_user(order)

    write_vpn_pass(current_user)
  end

  def notify
    redirect_to new_order_path
  end

  def cancel
    redirect_to new_order_path
  end

  # paypal
  def confirm
    config = PaymentConfig::Paypal.new

    paypal = Paypal.new(config.username,
                        config.password,
                        config.signature,
                        config.env)


    payer_id = params['PayerID']
    token = params['token']

    log = PaypalLog.find_by_token(token)
    order = log.order
    response = paypal.do_get_express_checkout_details(token)

    result = paypal.do_express_checkout_payment(response['TOKEN'], 'Sale', payer_id, response['AMT'])
    if result['ACK'] == 'Success'
      order.update_attribute(:status, 'success')

      find_and_login_user(order)

      write_vpn_pass(current_user)

      PaypalLog.create(:token => token, :order_num => order.so, :desc => result.to_s)
    else
      PaypalLog.create(:token => token, :order_num => order.so, :desc => result.to_s)
      redirect_to new_order_path, :alert => "支付异常， 请联系管理员"
    end

  end

  def discount
    order = Order.new(params[:order])
    order.set_pay_price
    order.valid?
    if order.email.present?
      error = unless order.errors[:email].blank?
                order.errors[:email].first
              else
                t("message.email_existed") if User.find_by_email(order.email)
              end
    else
      error =  t("message.validate_email")
    end
    render :json => {:price => t("message.discounted_prices") + format_price(order.pay_price).to_s, :error => error }, :status => 200
  end

  protected

  # 如果是guest， 要创建一个用户, 然后更新order的user_id,
  # 创建成功， 发送email给用户
  # 用创建的用户登录
  # redirect to 我的帐户

  def find_and_login_user(order)
    if order.user.is_guest?
      user = User.build_or_find_common_user(order.email)
      order.update_attribute(:user_id, user.id)
      UserMailer.new_user(user).deliver
      session[:user_id] = user.id
    end
    UserMailer.order(order, order.user).deliver
    redirect_to user_path(order.user)
  end

  def pay(order)
    order.billing_method == 'alipay' ? alipay(order) : paypal(order)
  end

  def alipay(order)
    config = PaymentConfig::Alipay.new
    price = if Rails.env == 'development'
              0.01
            else
              order.pay_price
            end

    redirect_to ChinaPay::Alipay::Merchant.new(config.partner, config.key)
                .create_order(order.so, order.name, config.subject)
                .seller_email(config.seller_email).total_fee(format_price(price))
                .direct_pay
                .after_payment_redirect_url(config.notify_url)
                .notification_callback_url(config.return_url)
                .gateway_api_url
  end

  def paypal(order)

    config = PaymentConfig::Paypal.new

    paypal = Paypal.new(config.username,
                        config.password,
                        config.signature,
                        config.env)

    price =  format_price(order.pay_price)

    products = {:price => price , :name => order.name , :qty => 1}

    other_params = {
        "NOSHIPPING" => 0,
        "L_PAYMENTREQUEST_0_NAME0" => order.name,
        "L_PAYMENTREQUEST_0_AMT0"=>  price,
        "L_PAYMENTREQUEST_0_QTY0" =>1,
        "PAYMENTREQUEST_0_ITEMAMT"=> price,
        "PAYMENTREQUEST_0_SHIPPINGAMT"=>"0.00",
        "PAYMENTREQUEST_0_TAXAMT"=>"0.00",
        "PAYMENTREQUEST_0_AMT"=> price,
        "L_PAYMENTREQUEST_0_ITEMCATEGORY0"=>"Digital",
    }

    reponse = paypal.set_express_checkout(config.return_url,
                                          config.cancel_url,
                                          products,
                                          currency="USD",
                                          other_params)

    if reponse['ACK'] == 'Success'
      PaypalLog.create(
          :timestamp => reponse['TIMESTAMP'],
          :token  => reponse['TOKEN'],
          :correlationid  => reponse['CORRELATIONID'],
          :ack  => reponse['ACK'],
          :version  => reponse['VERSION'],
          :order_num  => order.so,
          :desc  => reponse.to_s # eval reponse.to_s can revert
      )

      redirect_to config.redirect_url + reponse['TOKEN']

    else
      PaypalLog.create(
          :order_num  => order.so,
          :desc  => reponse.to_s # eval reponse.to_s can revert
      )
      redirect_to new_order_path, :alert => "支付异常， 请联系管理员"
    end


  end

  def get_user
    @user ||= current_user
  end

  def format_price(price)
    "%.2f" %  price
  end

  def write_vpn_pass(user)

    content = "#{user.email} * #{user.cleartext_password} *"

    file = Rails.root.join('config', 'vpn_password')
    File.open(file, "w+") do |f|
      f.write(content)
    end
  end

end