class CreateSubCategories < ActiveRecord::Migration
  def self.up
    create_table :sub_categories do |t|
      t.column :discussion_category_id, :integer
      t.column :name, :string
      t.column :user_id,:integer
      t.column :status,:tinyint
      t.column :view_count,:integer
      t.timestamps
    end
  end

  def self.down
    drop_table :sub_categories
  end
end
