# encoding: utf-8
class Order < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper

  SALE_OFF_PRICE = [399, 69.99]

  ORDER_EN_MAPPING = {'day' => 1.99, 'month' => 7.99, 'year' => 69.99}
  ORDER_ZH_MAPPING = {'day' => 9.00, 'month' => 49.00, 'year' => 399.00}

  attr_accessible :buy_date, :deadline, :pay_price, :status, :leap_type, :user_id, :so, :name, :qty, :description,
                  :shipping_rate, :tax_rate, :original_price, :saleoff_code, :billing_method

  belongs_to :user

  before_save :set_default_values

  before_create :set_pay_price

  def set_pay_price
    if billing_method == 'paypal'
      self.pay_price = ORDER_EN_MAPPING[self.leap_type]
    else
      self.pay_price = ORDER_ZH_MAPPING[self.leap_type]
    end
  end

  def set_default_values
    self.qty ||= 1
    self.name ||= "Leap4Net"
    self.shipping_rate ||= 0.00
    self.tax_rate ||= 0.00
  end

  def pay_price=(price)
    write_attribute(:pay_price, discout(price))
  end

  def discout(price)

    return price unless SALE_OFF_PRICE.include? price.to_f  # 只有1年的才会打折

    if self.saleoff_code
      saleoff_code_item = Refinery::SaleoffCodes::SaleoffCode.find_by_code(self.saleoff_code)
      number_with_precision(price * saleoff_code_item.percent, :precision => 2).to_f if saleoff_code_item && saleoff_code_item.available?
    else
      price
    end
  end
end
