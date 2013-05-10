class CreateDesigns < ActiveRecord::Migration
  def self.up
    create_table :designs do |t|
      t.column :category_id,                     :string, :limit => 100
      t.column :name,                      :string, :limit => 100, :unique => true
      t.column :description,                      :text
      t.column :status,                      :integer, :limit => 4
      t.column :user_id,                    :integer
      t.column :view_count  ,            :integer
      t.timestamps
    end
      add_index :designs, :name, :unique => true
  end

  def self.down
    remove_index :designs, :name
    drop_table :designs
  end
end
