class CreateShouts < ActiveRecord::Migration
  def self.up
    create_table :shouts do |t|
      t.column :user_id,                    :integer
      t.column :to_user_id,               :integer
      t.column :shout,                      :text
      t.column :status,                     :integer, :limit => 4
      t.timestamps
    end
  end

  def self.down
    drop_table :shouts
  end
end
