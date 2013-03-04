# encoding: utf-8

class AlipayLog < ActiveRecord::Base
  attr_accessible :body, :buyer_email, :buyer_id, :exterface, :is_success, :notify_id, :notify_time, :notify_type, :out_trade_no, :payment_type, :seller_email, :seller_id, :sign, :sign_type, :subject, :total_fee, :trade_no, :trade_status
  belongs_to :order, :primary_key => "so", :foreign_key => "out_trade_no"
end
