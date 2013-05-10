class AlterTags < ActiveRecord::Migration
  def self.up
     add_column :tags, :no_of_clicks, :integer
     add_column :tags, :tagable_type, :string, :limit => 50
     add_column :groups, :status, :integer, :limit => 4
  end

  def self.down
      remove_column :tags, :no_of_clicks
      remove_column :tags, :tagable_type
      remove_column :groups, :status
  end
end
