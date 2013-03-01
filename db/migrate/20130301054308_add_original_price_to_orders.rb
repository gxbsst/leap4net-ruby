class AddOriginalPriceToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :original_price, :float
    add_column :orders, :saleoff_code, :string
  end
end
