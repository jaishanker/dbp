class AddContestWinners < ActiveRecord::Migration
  def self.up
    add_column :contests, :winner1, :integer    
    add_column :contests, :winner2, :integer        
  end

  def self.down
    remove_column :contests, :winner1
    remove_column :contests, :winner2          
  end
end
