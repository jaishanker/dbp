class AddUsersProfileComplete < ActiveRecord::Migration
  def self.up
   add_column :users, :profile_complete, :integer       
  end

  def self.down
   remove_column :users, :profile_complete
  end
end
