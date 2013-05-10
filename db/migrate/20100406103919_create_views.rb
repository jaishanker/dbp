class CreateViews < ActiveRecord::Migration
  def self.up
    create_table :views do |t|
      t.column :count, :integer
      t.column :viewable_type, :string,:limit => 50
      t.column :viewable_id, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :views
  end
end
