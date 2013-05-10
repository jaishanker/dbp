class ChangeCategoryType < ActiveRecord::Migration
  def self.up
    change_column :designs, :category_id, :integer
    change_column :learnings, :category_id, :integer
    change_column :groups, :category_id, :integer    
  end

  def self.down
    change_column :designs, :category_id, :string
    change_column :learnings, :category_id, :string
    change_column :groups, :category_id, :string        
  end
end
