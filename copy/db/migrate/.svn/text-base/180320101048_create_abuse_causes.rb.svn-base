
class CreateAbuseCauses < ActiveRecord::Migration
  def self.up
    create_table :abuse_causes do |t|
      t.column :cause,                 :string
      t.column :description,           :string
      t.column :updated_at,            :datetime
      t.column :created_at,            :datetime
    end
    AbuseCause.create(:cause => 'General Abuse', :description => '')
    AbuseCause.create(:cause => "Profanity", :description => '')
    AbuseCause.create(:cause => 'Explicit Content', :description => '')
    AbuseCause.create(:cause => 'Impersonation', :description => '')
    AbuseCause.create(:cause => 'Harassment', :description => '')
    AbuseCause.create(:cause => 'Slander', :description => '')
    AbuseCause.create(:cause => 'Racial Abuse', :description => '')
    AbuseCause.create(:cause => 'Religious Abuse', :description => '')
    AbuseCause.create(:cause => 'Spam', :description => '')
    AbuseCause.create(:cause => 'Private Information', :description => '')
  end

  def self.down
    drop_table :abuse_causes
  end
end