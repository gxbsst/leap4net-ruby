class AddBeginDateAndDeadlineToUsers < ActiveRecord::Migration
  def change
     add_column :users, :begin_date, :datetime
     add_column :users, :deadline, :datetime
  end
end
