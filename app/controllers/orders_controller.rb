#encoding: utf-8

class OrdersController < ApplicationController
  before_filter :authenticate_user
  before_filter :get_user

  def new
    @order = Order.new
  end

  def create
    order = Order.new(params[:order])
    order.so = SecureRandom.hex
    order.user_id = @user.id

    if order.save
      pay(order)
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

    # TODO:
    # 如果是guest， 要创建一个用户, 然后更新order的user_id,
    # 创建成功， 发送email给用户
    # 用创建的用户登录

    # redirect to 我的帐户

  end

  def notify

  end

  def cancel

  end

  # paypal
  def confirm
    username = "test2_1356319825_biz_api1.sidways.com"
    password = "1356319845"
    signature = "An5ns1Kso7MWUdW4ErQKJJJ4qi4-AocZDCOBqHkdTuMA3quFqSyX5ilB";

    paypal = Paypal.new(username, password, signature, :sandbox)

    payer_id = params['PayerID']
    token = params['token']

    log = PaypalLog.find_by_token(token)
    order = log.order
    response = paypal.do_get_express_checkout_details(token)

    result = paypal.do_express_checkout_payment(response['TOKEN'], 'Sale', payer_id, response['AMT'])
    if result['ACK'] == 'Success'
      order.update_attribute(:status, 'success')

      # TODO:
      # 如果是guest， 要创建一个用户, 然后更新order的user_id,
      # 创建成功， 发送email给用户
      # 用创建的用户登录

      # redirect to 我的帐户

      PaypalLog.create(:token => token, :order_num => order.so, :desc => result.to_s)
    else
      PaypalLog.create(:token => token, :order_num => order.so, :desc => result.to_s)
      redirect_to new_order_path, :alert => "支付异常， 请联系管理员"
    end

  end

  protected

  def pay(order)
    order.billing_method == 'alipay' ? alipay(order) : paypal(order)
  end

  def alipay(order)
    redirect_to ChinaPay::Alipay::Merchant.new('2088801240842311', 'yf46ds05nkrwdggnmftchrk83tpaza5j')
                .create_order(order.so, order.name, 'leap4net vpn')
                .seller_email('shannon.mao@sidways.com').total_fee(0.01)
                .direct_pay
                .after_payment_redirect_url('http://leap4.local/orders/success')
                .notification_callback_url('http://leap4.local/orders/notify')
                .gateway_api_url
  end

  def paypal(order)

    username = "test2_1356319825_biz_api1.sidways.com"
    password = "1356319845"
    signature = "An5ns1Kso7MWUdW4ErQKJJJ4qi4-AocZDCOBqHkdTuMA3quFqSyX5ilB"
    return_url = "http://localhost:3000/orders/confirm"
    cancel_url =  "http://localhost:3000/orders/cancle"

    products = {:price => order.pay_price , :name => order.name , :qty => 1}

    paypal = Paypal.new(username, password, signature, :sandbox)

    other_params = {
        "NOSHIPPING" => 0,
        "L_PAYMENTREQUEST_0_NAME0" => order.name,
        "L_PAYMENTREQUEST_0_AMT0"=>  order.pay_price,
        "L_PAYMENTREQUEST_0_QTY0" =>1,
        "PAYMENTREQUEST_0_ITEMAMT"=> order.pay_price,
        "PAYMENTREQUEST_0_SHIPPINGAMT"=>"0.00",
        "PAYMENTREQUEST_0_TAXAMT"=>"0.00",
        "PAYMENTREQUEST_0_AMT"=> order.pay_price,
        "L_PAYMENTREQUEST_0_ITEMCATEGORY0"=>"Digital",
    }
    reponse = paypal.set_express_checkout(return_url, cancel_url, products, currency="USD", other_params)

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
      redirect_to "https://www.sandbox.paypal.com/incontext?token=#{reponse['TOKEN']}"
      # production
      #redirect_to "https://www.paypal.com/incontext?token=#{reponse['TOKEN']}"
    else
      PaypalLog.create(
          :order_num  => order.so,
          :desc  => reponse.to_s # eval reponse.to_s can revert
      )
      redirect_to new_order_path, :alert => "支付异常， 请联系管理员"
    end

    ## if reponse['ACK'] == 'Success'

    ## Failed
    #{"TIMESTAMP"=>"2013-02-27T09:12:57Z",
    # "CORRELATIONID"=>"bae4f7e947655",
    # "ack"=>"Failure",
    # "version"=>"74.0",
    # "build"=>"5331358",
    # "l_errorcode0"=>"10609",
    # "l_shortmessage0"=>"Invalid transactionID.",
    # "l_longmessage0"=>"Transaction id is invalid.",
    # "l_severitycode0"=>"Error"}

    ## Success
    #{"TOKEN"=>"EC-31J741543X637323Y",
    # "TIMESTAMP"=>"2013-02-27T09:20:10Z",
    # "CORRELATIONID"=>"353b5b7c824f",
    # "ACK"=>"Success",
    # "VERSION"=>"74.0",
    # "BUILD"=>"5331358"}

    # test
    #redirect_to "https://www.sandbox.paypal.com/incontext?token=#{reponse['TOKEN']}"

    # production
    #redirect_to "https://www.paypal.com/incontext?token=#{reponse['TOKEN']}"
    ## 用户付款完成后会返回到return url， 通过这个url 可以得到:PayerID 和 token，
    ## 这个return url  要做一个do_express_checkout_payment


    #paypal.do_get_express_checkout_details(reponse['TOKEN'])
    #paypal.do_express_checkout_payment(reponse['TOKEN'],'Sale', "payer_id", 0.01)
  end



  def get_user
    @user ||= current_user
  end

end