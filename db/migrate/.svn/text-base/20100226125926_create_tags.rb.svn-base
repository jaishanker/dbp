class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.column :name,                     :string, :limit => 100, :unique => true
      t.column :status,                      :integer, :limit => 4
      t.timestamps
    end
       add_index :tags, :name, :unique => true
  end

  def self.down
    remove_index :tags, :name
    drop_table :tags
  end
end
