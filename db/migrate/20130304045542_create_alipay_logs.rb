class CreateAlipayLogs < ActiveRecord::Migration
  def change
    create_table :alipay_logs do |t|
      t.string :body
      t.string :buyer_email
      t.string :buyer_id
      t.string :exterface
      t.string :is_success
      t.string :notify_id
      t.string :notify_time
      t.string :notify_type
      t.string :out_trade_no
      t.string :payment_type
      t.string :seller_email
      t.string :seller_id
      t.string :subject
      t.string :total_fee
      t.string :trade_no
      t.string :trade_status
      t.string :sign
      t.string :sign_type

      t.timestamps
    end
  end
end
