class AddNewsSubscribeInUser < ActiveRecord::Migration
  def self.up
    add_column :users, :news_subscribe, :integer
  end

  def self.down
     remove_column :users, :news_subscription
  end
end
