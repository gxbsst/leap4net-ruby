class AddSoToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :so, :string
    add_column :orders, :name, :string
    add_column :orders, :qty, :integer
    add_column :orders, :description, :text
    add_column :orders, :shipping_rate, :float
    add_column :orders, :tax_rate, :float
  end
end
