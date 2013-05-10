class AddUserType < ActiveRecord::Migration
  def self.up
    add_column :users, :user_type,:integer, :limit => 4
  end

  def self.down
    
    remove_column :users,:user_type
    
  end
end
