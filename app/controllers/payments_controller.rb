# encoding: utf-8
class PaymentsController < ApplicationController

  def create
      # Generate A Order
      order = Order.create(:price)
      # payment
  end

  def alipay
      redirect_to ChinaPay::Alipay::Merchant.new('2088801240842311', 'yf46ds05nkrwdggnmftchrk83tpaza5j')
                  .create_order('KC20130132200001D', 'iPhone 5 ', '感谢您购买 ！')
                  .seller_email('shannon.mao@sidways.com').total_fee(0.01)
                  .direct_pay
                  .after_payment_redirect_url('http://www.sidways.lab/success')
                  .notification_callback_url('http://www.sidways.lab/notify')
                  .gateway_api_url
  end

  def paypal

    username = "test2_1356319825_biz_api1.sidways.com";
    password = "1356319845";
    signature = "An5ns1Kso7MWUdW4ErQKJJJ4qi4-AocZDCOBqHkdTuMA3quFqSyX5ilB";
    return_url = "http://localhost:3000/payments/confirm"
    cancel_url =  "http://localhost:3000/payments/cancle"
    #ipaddress = '192.168.1.1' # can be any IP address
    #amount = '0.01' # amount paid
    #card_type = 'VISA' # can be Visa, Mastercard, Amex etc
    #card_no = '4512345678901234' # credit card number
    #exp_date = '022010' # expiry date of the credit card
    #first_name = 'Sau Sheong'
    #last_name = 'Chang'
    products = {:price => "0.01", :name => "Leap4Net ", :qty => 1}

    paypal = Paypal.new(username, password, signature, :sandbox)

    other_params = {
        "L_PAYMENTREQUEST_0_NAME0" =>"Leap4Net",
        "L_PAYMENTREQUEST_0_AMT0"=> "0.01",
        "L_PAYMENTREQUEST_0_NUMBER0" => "ABC123",
        "L_PAYMENTREQUEST_0_QTY0" =>1,
        "PAYMENTREQUEST_0_ITEMAMT"=>"0.01",
        "PAYMENTREQUEST_0_SHIPPINGAMT"=>"0.00",
        "PAYMENTREQUEST_0_TAXAMT"=>"0.00",
        "PAYMENTREQUEST_0_AMT"=>"0.01",
        #"REQCONFIRMSHIPPING" => 0,
        #"NOSHIPPING"=> 1,
        #"L_PAYMENTREQUEST_0_NAME0"=> "Leap4Net",
        #"L_PAYMENTREQUEST_0_AMT0" => "0.01",
        #"L_PAYMENTREQUEST_0_QTY0"=>"1",
        "L_PAYMENTREQUEST_0_ITEMCATEGORY0"=>"Digital",
        #"PAYMENTREQUEST_0_ITEMAMT"=> "458.00",
        #"PAYMENTREQUEST_0_SHIPPINGAMT"=>"20.00",
        #"PAYMENTREQUEST_0_TAXAMT"=>"46.20",
        #"PAYMENTREQUEST_0_PAYMENTACTION" => 'Sale'
    }
    reponse = paypal.set_express_checkout(return_url, cancel_url, products, currency="USD", other_params)

    ## if reponse['ACK'] == 'Success'

    ## Failed
    #{"TIMESTAMP"=>"2013-02-27T09:12:57Z",
    # "CORRELATIONID"=>"bae4f7e947655",
    # "ACK"=>"Failure",
    # "VERSION"=>"74.0",
    # "BUILD"=>"5331358",
    # "L_ERRORCODE0"=>"10609",
    # "L_SHORTMESSAGE0"=>"Invalid transactionID.",
    # "L_LONGMESSAGE0"=>"Transaction id is invalid.",
    # "L_SEVERITYCODE0"=>"Error"}

    ## Success
    #{"TOKEN"=>"EC-31J741543X637323Y",
    # "TIMESTAMP"=>"2013-02-27T09:20:10Z",
    # "CORRELATIONID"=>"353b5b7c824f",
    # "ACK"=>"Success",
    # "VERSION"=>"74.0",
    # "BUILD"=>"5331358"}

    # test
    redirect_to "https://www.sandbox.paypal.com/incontext?token=#{reponse['TOKEN']}"

    # production
    #redirect_to "https://www.paypal.com/incontext?token=#{reponse['TOKEN']}"
    ## 用户付款完成后会返回到return url， 通过这个url 可以得到:PayerID 和 token，
    ## 这个return url  要做一个do_express_checkout_payment


    #paypal.do_get_express_checkout_details(reponse['TOKEN'])
    #paypal.do_express_checkout_payment(reponse['TOKEN'],'Sale', "payer_id", 0.01)
  end

  def confirm
    username = "test2_1356319825_biz_api1.sidways.com"
    password = "1356319845"
    signature = "An5ns1Kso7MWUdW4ErQKJJJ4qi4-AocZDCOBqHkdTuMA3quFqSyX5ilB";
    return_url = "http://localhost:3000/payments/confirm"
    cancel_url =  "http://localhost:3000/payments/cancle"
    #ipaddress = '192.168.1.1' # can be any IP address
    #amount = '0.01' # amount paid
    #card_type = 'VISA' # can be Visa, Mastercard, Amex etc
    #card_no = '4512345678901234' # credit card number
    #exp_date = '022010' # expiry date of the credit card
    #first_name = 'Sau Sheong'
    #last_name = 'Chang'
    products = {:price => "0.01", :name => "Leap4Net ", :qty => 1}

    paypal = Paypal.new(username, password, signature, :sandbox)

    payer_id = params['PayerID']
    token = params['token']

    response = paypal.do_get_express_checkout_details(token)

    binding.pry
    result = paypal.do_express_checkout_payment(response['TOKEN'], 'Sale', payer_id, response['AMT'])
    if result['ACK'] == 'Success'
      # TODO somthing
    else
      # TODO somthing
    end


  end

end