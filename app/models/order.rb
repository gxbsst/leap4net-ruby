class Order < ActiveRecord::Base
  attr_accessible :buy_date, :deadline, :pay_price, :status, :leap_type, :user_id

  belongs_to :user
end
