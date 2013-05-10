class AddUserExpertisePoints < ActiveRecord::Migration
  def self.up
    add_column :users, :expertise_points, :integer,  :default => 0    
  end

  def self.down
    remove_column :users, :expertise_points
  end
end
