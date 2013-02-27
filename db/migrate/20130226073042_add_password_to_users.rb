class AddPasswordToUsers < ActiveRecord::Migration
  def change
    add_column :users, :cleartext_password, :string
  end
end
