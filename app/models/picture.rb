class Picture < ActiveRecord::Base
  
  belongs_to :gallerie, :polymorphic => true
  has_attached_file :photo,
  :styles => {
    :thumb=> "36x36#",
    :thumb_large=> "98x98#",
    :small=> "139x77#",
    :medium=> "177x133#",
    :large=> "500>x275",
    :large_preview=> "500x275#"
  }
  
  validates_attachment_presence :photo#,:unless => :ie_browser                    
  validates_attachment_size :photo, :less_than=>5.megabyte, :greater_than => 1.kilobyte#,:unless => :ie_browser       
  validates_attachment_content_type :photo,
    :content_type=>['image/jpg','image/jpeg','image/pjpeg', 'image/png', 'image/gif', 'image/tiff']#,:unless => :ie_browser       
  
  attr_accessor :version
  
  after_save :resize_banner_image
  
  def self.process_all
    find(:all).each do |p|
      p.photo.reprocess!
    end
  end
  
  
  def ie_browser
    if version == "IE"
      return true
    else
      return false
    end
  end
  
  def resize_banner_image
    if gallerie_type == "Banner"
      path = (Rails.root.to_s+"/public"+photo.url).to_s
      p1=path.gsub(/\?[0-9]+/,"")      
      cmd = "convert -resize 239x199! " + p1  + " "+ p1
      system(cmd)      
    end    
  end
  
end
