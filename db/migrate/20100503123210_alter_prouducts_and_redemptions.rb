class AlterProuductsAndRedemptions < ActiveRecord::Migration
  def self.up
    add_column :products, :products_available, :integer
    add_column :redemptions, :points, :integer    
  end

  def self.down
    remove_column :products, :products_available
    remove_column :redemptions, :points, :integer        
  end
end
