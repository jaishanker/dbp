class CreateUserProfessions < ActiveRecord::Migration
  def self.up
    create_table :user_professions do |t|
     t.column :user_id,                     :integer
     t.column :employer,                      :string, :limit => 100
     t.column :position,                      :string, :limit => 100
     t.column :industry,                      :string, :limit => 100
     t.column :duration,                      :integer
     t.timestamps
    end
  end

  def self.down
    drop_table :user_professions
  end
end
