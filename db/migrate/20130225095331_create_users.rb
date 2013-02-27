class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, :limit => 11
      t.string :user_type, :limit => 11
      t.string :password, :limit => 11

      t.timestamps
    end
  end
end
