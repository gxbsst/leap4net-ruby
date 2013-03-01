class AddBillingMethodToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :billing_method, "ENUM('paypal', 'alipay')"
  end
end
