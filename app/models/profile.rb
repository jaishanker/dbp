class Profile < ActiveRecord::Base
  include URI
  belongs_to :user
  has_many :activity_streams, :as => :actor, :dependent => :destroy  
  has_many :activity_streams, :as => :object, :dependent => :destroy     
  attr_accessor :total_exp_months  
  
#  validates_format_of :website,  :with => /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix
   validates_format_of :website, :with => URI::regexp(%w(http https)), :message => "Website URL is invalid", :allow_blank => true
   validates_format_of :comm_site_1, :with => URI::regexp(%w(http https)), :message => "Community website URL 1 is invalid", :allow_blank => true
   validates_format_of :comm_site_2, :with => URI::regexp(%w(http https)), :message => "Community website URL 2 is invalid", :allow_blank => true
   validates_format_of :comm_site_3, :with => URI::regexp(%w(http https)), :message => "Community website URL 3 is invalid", :allow_blank => true
   validates_format_of :blog_1, :with => URI::regexp(%w(http https)), :message => "Blog URL 1 is invalid", :allow_blank => true
   validates_format_of :blog_2, :with => URI::regexp(%w(http https)), :message => "Blog URL 2 is invalid", :allow_blank => true
   validates_format_of :blog_3, :with => URI::regexp(%w(http https)), :message => "Blog URL 3 is invalid", :allow_blank => true 

#  after_create :create_permalink  
  
  define_completeness_scoring do
         check :pic_present,                    lambda { |per| per.pic_present.present? },  :high
         check :diploma,                    lambda { |per| per.diploma.present? },  :medium
        check :be,                    lambda { |per| per.be.present? },  :medium        
        check :masters,                    lambda { |per| per.masters.present? },  :medium                
        check :graduation_year,         lambda { |per| per.graduation_year.present? },  :medium
        check :total_exp,         lambda { |per| per.total_exp.present? },  :medium 
        check :cswe,         lambda { |per| per.cswe.present? },  :medium     
        check :solidworks_associate,         lambda { |per| per.solidworks_associate.present? },  :medium      
        check :cswp,         lambda { |per| per.cswp.present? },  :medium     
        check :cswp_surface_prof,          lambda { |per| per.cswp_surface_prof.present? },  :medium      
        check :cswp_shetmetal_prof,          lambda { |per| per.cswp_shetmetal_prof.present? },  :medium      
        check :cswp_mold_tools,          lambda { |per| per.cswp_mold_tools.present? },  :medium              
        check :cswsp,         lambda { |per| per.cswsp.present? },  :medium     
        check :solidworks_version,                      lambda { |per| per.solidworks_version.present? },  :medium
        check :simulation_version,                      lambda { |per| per.simulation_version.present? },  :medium  
        check :epdm_version,                      lambda { |per| per.epdm_version.present? },  :medium   
        check :solidworks_3d_version,                      lambda { |per| per.solidworks_3d_version.present? },  :medium  
        check :solidwork_usege_exp,                      lambda { |per| per.solidwork_usege_exp.present? },  :medium      
        check :cad_usage_exp,                      lambda { |per| per.cad_usage_exp.present? },  :medium
#        check :skills,                     lambda { |per| per.skills.present? },  :medium 
    end
    
#  def create_permalink
#    design_name = self.name.downcase.gsub(" ", "-").gsub("/","-")
#    self.permalink = "#{self.id}-#{design_name}"
#    self.save
#  end   
  
end
