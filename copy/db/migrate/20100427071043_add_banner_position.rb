class AddBannerPosition < ActiveRecord::Migration
  def self.up
    add_column :banners,:banner_position,:string
  end
  
  def self.down
    remove_column :banners,:banner_position
  end
end
