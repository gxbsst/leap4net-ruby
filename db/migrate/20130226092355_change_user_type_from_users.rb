class ChangeUserTypeFromUsers < ActiveRecord::Migration
  def up
    change_column :users, :user_type, "ENUM('Guest', 'Common', 'Disabled')", :default => 'Guest', :null => false
  end

  def down
  end
end
