class CreateCampaigns < ActiveRecord::Migration
  def self.up
    create_table :campaigns do |t|
      t.column :title,                  :string, :limit => 100
      t.column :camp_id,                :integer
      t.timestamps
    end
    Campaign.create(:title => "Activation", :camp_id => 10007)
    Campaign.create(:title => "Comment", :camp_id => 10001)
    Campaign.create(:title => "Favorite", :camp_id => 10004)
    Campaign.create(:title => "Follow", :camp_id => 10003)
    Campaign.create(:title => "Forgot Password", :camp_id => 10006)
    Campaign.create(:title => "Group Activation", :camp_id => 10008)
    Campaign.create(:title => "Group Creation", :camp_id => 10009)
    Campaign.create(:title => "Deactivation", :camp_id => 10010)
    Campaign.create(:title => "Rating", :camp_id => 10002)
    Campaign.create(:title => "Signup", :camp_id => 10005)        
  end

  def self.down
    drop_table :campaigns
  end
end
