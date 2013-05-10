class AddNewsUpdates < ActiveRecord::Migration
  def self.up
    add_column :news, :start_date, :date
    add_column :news, :end_date, :date
    add_column :news, :embed_code, :text
    add_column :news, :category_id, :integer
  
  end
  
  def self.down
    remove_column :news, :start_date
    remove_column :news, :end_date
    remove_column :news, :embed_code
    remove_column :news, :embed_code
 
  end
end
