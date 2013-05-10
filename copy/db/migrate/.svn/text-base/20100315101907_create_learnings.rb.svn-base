class CreateLearnings < ActiveRecord::Migration
  def self.up
    create_table :learnings do |t|
      t.column :title,                  :string, :limit => 100, :unique => true
      t.column :description,            :text
      t.column :category_id,            :string, :limit => 100
      t.column :status,                 :integer, :limit => 4
      t.column :user_id,                :integer
      t.column :view_count,             :integer
      t.column :format,                 :string
      t.column :embed_code,             :string
      t.column :position,               :integer
      t.column :upload_material,        :string, :limit => 150
      t.column :size,                   :integer  
      t.column :tags,                   :string, :limit => 100
      t.timestamps
    end
    add_index :learnings, :title, :unique => true
  end
  
  def self.down
    remove_index :learnings, :title
    drop_table :learnings
  end
end