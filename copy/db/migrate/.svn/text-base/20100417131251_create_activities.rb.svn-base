class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.column :user_id,                :integer      
      t.column :activity,                  :string, :limit => 100
      t.column :object_id,            :integer
      t.column :object_type,                  :string, :limit => 100
      t.column :points_earned,             :integer
      t.column :points_spend,             :integer      
      t.column :points_substracted,             :integer            
      t.timestamps
    end
  end

  def self.down
    drop_table :activities
  end
end
