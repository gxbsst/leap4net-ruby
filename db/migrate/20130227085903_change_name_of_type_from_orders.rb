class ChangeNameOfTypeFromOrders < ActiveRecord::Migration
  def up
    rename_column :orders, :type, :leap_type
  end

  def down
    rename_column :orders, :leap_type, :type
  end
end
