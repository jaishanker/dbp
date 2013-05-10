class CampLog < ActiveRecord::Migration
  def self.up
    create_table :camp_logs do |t|
      t.column :user_id, :integer
      t.column :camp_id, :integer
      t.timestamps
    end
  end
  
  def self.down
    drop_table :camp_logs
  end
end
