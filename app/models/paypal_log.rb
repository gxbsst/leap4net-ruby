class PaypalLog < ActiveRecord::Base
  attr_accessible :ack, :correlationid, :desc, :order_num, :timestamp, :token, :version
  belongs_to :order, :primary_key => "so", :foreign_key => "order_num"
end
