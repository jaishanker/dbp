class AddRedemptionDetails < ActiveRecord::Migration
  def self.up
    add_column :redeem_user_infos, :tel_no, :string, :limit => 30     
    add_column :redeem_user_infos, :mob_no, :string, :limit => 30         
    add_column :redeem_user_infos, :shipment_type, :integer, :limit => 4 
    add_column :redemptions, :approved, :integer, :limit => 4  
    add_column :redemptions, :shifted, :integer, :limit => 4      
    add_column :products, :shipment_cost, :integer       
  end

  def self.down
    remove_column :redeem_user_infos, :tel_no
    remove_column :redeem_user_infos, :mob_no 
    remove_column :redeem_user_infos, :shipment_type     
    remove_column :redemptions, :approved
    remove_column :redemptions, :shifted    
    remove_column :products, :shipment_cost
  end
end
