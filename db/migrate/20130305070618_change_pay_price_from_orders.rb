class ChangePayPriceFromOrders < ActiveRecord::Migration
  def up
    change_column :orders, :pay_price, :decimal, :precision => 8, :scale => 2
  end

  def down
    change_column :orders, :pay_price, :float
  end
end
