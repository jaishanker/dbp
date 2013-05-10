class AddActiveRequests < ActiveRecord::Migration
  def self.up
    add_column :requests,:active,:integer, :limit => 4    
  end

  def self.down
    add_column :requests,:active 
  end
end
