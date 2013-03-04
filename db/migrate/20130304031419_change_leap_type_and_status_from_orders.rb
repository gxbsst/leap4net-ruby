class ChangeLeapTypeAndStatusFromOrders < ActiveRecord::Migration
  def up
    change_column :orders, :leap_type, "ENUM('day', 'month', 'year')", :null => false
     change_column :orders, :status, "ENUM('success', 'failure', 'overdue')"
  end

  def down
  end
end
