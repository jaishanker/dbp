class CreateBanners < ActiveRecord::Migration
  def self.up
    create_table :banners do |t|
      t.column :name,            :string, :limit => 100
      t.column :banner_type,            :string, :limit => 100
      t.column :banner_code,            :text
      t.column :banner_page,            :string, :limit => 100
      t.column :status,                 :integer, :limit => 4
      t.timestamps
    end
  end

  def self.down
    drop_table :banners
  end
end
