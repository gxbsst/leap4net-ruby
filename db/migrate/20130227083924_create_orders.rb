class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.column :type, "ENUM('One_day', 'Half_a_year', 'One_year')"
      t.column :status, "ENUM('Pay_success', 'Pay_failure', 'Overdue')"
      t.decimal :pay_price
      t.datetime :buy_date
      t.datetime :deadline
      t.integer :user_id

      t.timestamps
    end
  end
end
