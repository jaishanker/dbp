class CreateNews < ActiveRecord::Migration
  def self.up
    create_table :news do |t|
      t.column :title,                  :string, :limit => 100
      t.column :description,            :text
      t.column :status,                 :integer, :limit => 4
      t.column :user_id,                :integer
      t.column :view_count,             :integer
      t.timestamps
    end
  end
  
  def self.down
    drop_table :news
  end
end