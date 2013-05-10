class AddBannerLinks < ActiveRecord::Migration
  def self.up
    add_column :banners,:banner_link,:string
  end

  def self.down
    remove_column :banners,:banner_link
  end
end
