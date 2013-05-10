class AddDiplomaBeMastersToProfiles < ActiveRecord::Migration
  def self.up
    add_column :profiles, :diploma, :string, :limit => 5
    add_column :profiles,:be, :string, :limit => 5  
    add_column :profiles,:masters, :string, :limit => 5    
  end

  def self.down
    remove_column :profiles, :diploma
    remove_column :profiles, :be
    remove_column :profiles, :masters        
  end
end
