class Participation < ActiveRecord::Base
  has_many :participations
  has_many :contests, :through => :participations
  
  has_many  :assets, :as => :attachable, :dependent => :destroy
  has_many :pictures, :as => :gallerie    
  
validates_acceptance_of :terms_of_service  
end
