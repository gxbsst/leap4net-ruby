# encoding: utf-8
class Order < ActiveRecord::Base

  SALE_OFF_PRICE = [399, 69.99]
  attr_accessible :buy_date, :deadline, :pay_price, :status, :leap_type, :user_id, :so, :name, :qty, :description,
                  :shipping_rate, :tax_rate, :original_price, :saleoff_code

  belongs_to :user

  before_save :set_default_values

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
      price * saleoff_code_item.percent if saleoff_code_item && saleoff_code_item.available?
    else
      price
    end
  end
end
