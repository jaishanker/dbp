class AddPermalinks < ActiveRecord::Migration
  def self.up
        add_column :designs, :permalink, :string
        add_column :learnings, :permalink, :string        
#        add_column :contests, :permalink, :string        
        add_column :events, :permalink, :string      
        add_column :games, :permalink, :string      
        add_column :groups, :permalink, :string      
        add_column :news, :permalink, :string  
#        add_column :profiles, :permalink, :string      
        add_column :topics, :permalink, :string      
        
      Design.find(:all).each(&:save)
       Learning.find(:all).each(&:save)
       Event.find(:all).each(&:save)
       Game.find(:all).each(&:save)
       Group.find(:all).each(&:save)
       News.find(:all).each(&:save)
       Topic.find(:all).each(&:save)    
  end

  def self.down
        remove_column :designs, :permalink
        remove_column :learnings, :permalink      
#        remove_column :contests, :permalink
        remove_column :events, :permalink
        remove_column :games, :permalink
        remove_column :groups, :permalink
        remove_column :news, :permalink
#        remove_column :profiles, :permalink
        remove_column :topics, :permalink
  end
end
