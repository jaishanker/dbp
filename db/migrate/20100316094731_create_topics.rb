class CreateTopics < ActiveRecord::Migration
  def self.up
    create_table :topics do |t|
      t.column :discussion_category_id,:integer
      t.column :sub_category_id,:integer
      t.column :user_id,:integer
      t.column :title,:string
      t.column :view_count,:integer
      t.column :status,:integer
      t.timestamps
    end
  end

  def self.down
    drop_table :topics
  end
end
