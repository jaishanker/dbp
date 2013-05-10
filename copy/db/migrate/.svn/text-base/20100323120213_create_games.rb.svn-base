class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      t.column :title,                  :string, :limit => 100
      t.column :description,            :text
      t.column :status,                 :integer, :limit => 4
      t.column :user_id,                :integer
      t.column :view_count,             :integer
      t.column :tags,                   :string
      t.column :embed_code,             :text
      t.timestamps
    end
  end
  
  def self.down
    drop_table :games
  end
end
