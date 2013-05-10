class AddCreatedUpdatedDate < ActiveRecord::Migration
  def self.up
    add_column :report_abuses, :created_at, :datetime
    add_column :report_abuses, :updated_at, :datetime
  
  end
  
  def self.down
    remove_column :report_abuses, :created_at, :datetime
    remove_column :report_abuses, :updated_at, :datetime
 
  end
end
