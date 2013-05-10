class AddStatusFavorites < ActiveRecord::Migration
  def self.up
    add_column :favorites, :status, :integer, :limit => 4, :default => 1
  end

  def self.down
    remove_column :favorites, :status
  end
end
