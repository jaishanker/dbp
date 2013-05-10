class AddSubCategoryDescription < ActiveRecord::Migration
  def self.up
    add_column :sub_categories, :description, :string
  end
  
  def self.down
    remove_column :sub_categories, :description
  end
end
