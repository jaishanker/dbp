class AddStateCityPincodeToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :state, :string, :limit => 50
    add_column :users, :city, :string, :limit => 50   
    add_column :users, :pincode, :string, :limit => 20   
  end

  def self.down
    remove_column :users, :state
    remove_column :users, :city
    remove_column :users, :pincode    
  end
end
