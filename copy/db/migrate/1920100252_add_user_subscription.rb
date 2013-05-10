class AddUserSubscription < ActiveRecord::Migration
  def self.up
    add_column :users,:subscribe,:integer, :default => 1
  end

  def self.down
    remove_column :users,:subscribe
  end
end
