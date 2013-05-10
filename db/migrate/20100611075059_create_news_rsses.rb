class CreateNewsRsses < ActiveRecord::Migration
  def self.up
    create_table :news_rsses do |t|
      t.column :title, :string
      t.column :link, :string
      t.column :status, :integer ,:limit => 4
      t.timestamps
    end
  end
  
  def self.down
    drop_table :news_rsses
  end
end
