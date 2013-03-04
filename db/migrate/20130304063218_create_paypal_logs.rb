class CreatePaypalLogs < ActiveRecord::Migration
  def change
    create_table :paypal_logs do |t|
      t.string :timestamp
      t.string :correlationid
      t.string :ack
      t.string :version
      t.string :token
      t.string :order_num
      t.text :desc

      t.timestamps
    end
  end
end
