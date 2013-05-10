class Tag < ActiveRecord::Base

  belongs_to :tagable, :polymorphic => true
  
  def self.popular_tags
    find(:all, :limit => 8,:conditions => "status = 1", :order => "no_of_clicks desc")
  end
end
