class CreatePictures < ActiveRecord::Migration
  def self.up
    create_table :pictures do |t|
      t.column :photo_file_name,                      :string, :limit => 100
      t.column :photo_content_type,                     :string, :limit => 50
      t.column :photo_file_size,                      :integer
      t.column :gallerie_id,                    :integer
      t.column :gallerie_type,                     :string, :limit => 25
      t.timestamps
    end
  end

  def self.down
    drop_table :pictures
  end
end
