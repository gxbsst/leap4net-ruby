class ChangePasswordDigestFromUsers < ActiveRecord::Migration
  def up
    change_column :users, :password_digest, :string
  end

  def down
  end
end
