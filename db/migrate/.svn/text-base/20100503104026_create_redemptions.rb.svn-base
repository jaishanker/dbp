class CreateRedemptions < ActiveRecord::Migration
  def self.up
    create_table :redemptions do |t|
      t.column :user_id,                :integer     
      t.column :product_id,          :integer
      t.column :status,                 :integer, :limit => 4, :default => 1      
      t.timestamps
    end
  end

  def self.down
    drop_table :redemptions
  end
end
