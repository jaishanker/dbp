class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.column :title,                  :string, :limit => 100
      t.column :description,            :text
      t.column :status,                 :integer, :limit => 4
      t.column :expiry_date,            :date
      t.column :product_count,          :integer
      t.column :points_required,          :integer
      t.timestamps
    end
  end
  
  def self.down
    drop_table :products
  end
end
