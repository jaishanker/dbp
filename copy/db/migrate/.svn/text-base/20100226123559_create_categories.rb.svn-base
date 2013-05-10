class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
     t.column :name,                    :string, :limit => 100
     t.column :description,                      :string, :limit => 1000
     t.column :type,                      :string, :limit => 50
     t.column :status,                      :integer, :limit => 4
     t.timestamps
    end
  end

  def self.down
    drop_table :categories
  end
end
