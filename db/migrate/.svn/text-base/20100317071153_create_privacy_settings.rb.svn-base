class CreatePrivacySettings < ActiveRecord::Migration
  def self.up
    create_table :privacy_settings do |t|
      t.column :user_id,                     :integer
      t.column :basic_info_member,                  :boolean, :default => 1
      t.column :basic_info_following,                  :boolean, :default => 1
      t.column :qualification_member,                  :boolean, :default => 1
      t.column :qualification_following,                  :boolean, :default => 1
      t.column :profession_member,                  :boolean, :default => 1
      t.column :profession_following,                  :boolean, :default => 1
      t.column :certification_member,                  :boolean, :default => 1
      t.column :certification_following,                  :boolean, :default => 1
      t.column :designs_member,                  :boolean, :default => 1
      t.column :designs_following,                  :boolean, :default => 1      
      t.column :requests_member,                  :boolean, :default => 0
      t.column :requests_following,                  :boolean, :default => 1          
      t.column :followings_member,                  :boolean, :default => 0
      t.column :followings_following,                  :boolean, :default => 1          
      t.column :followers_member,                  :boolean, :default => 0
      t.column :followers_following,                  :boolean, :default => 1          
      t.column :favourites_member,                  :boolean, :default => 0
      t.column :favourites_following,                  :boolean, :default => 1          
      t.column :groups_member,                  :boolean, :default => 1
      t.column :groups_following,                  :boolean, :default => 1          
      t.column :contests_member,                  :boolean, :default => 0
      t.column :contests_following,                  :boolean, :default => 1   
      t.timestamps
    end
  end

  def self.down
    drop_table :privacy_settings
  end
end
