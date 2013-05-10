class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.column :name,                     :string, :limit => 50
      t.column :description,                      :text
      t.column :category,                      :string, :limit => 50    
      t.column :type,                      :string, :limit => 50           
      t.column :recent_news,                      :text
      t.column :office,                     :string, :limit => 50
      t.column :email,          :string, :limit => 50
      t.column :website,                      :string, :limit => 50
      t.column :country,                     :string, :limit => 50
      t.column :street_adds,                     :string
      t.column :city,                     :string, :limit => 50
      t.column :owner_id,                     :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :groups
  end
end
