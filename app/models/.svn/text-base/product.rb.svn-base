class Product < ActiveRecord::Base
  
  validates_presence_of :title,:description
  validates_uniqueness_of :title
  validates_numericality_of :product_count,:points_required, :shipment_cost ,:greater_than => 0
  validates_date :expiry_date,:after => Proc.new {Date.today}
  validates_associated :pictures
  
  
  has_many :pictures, :as => :gallerie  
  has_many :redemptions
  
  cattr_reader :per_page
  @@per_page =PER_PAGE  
  
  
  
  def self.find_all
    find(:all,:order => "created_at DESC")
  end
  
  
  def self.available_products(page)
    current_date = Date.today().to_s(:db)    
    paginate :page => page,
      :conditions => ['status = 1 and products_available > 0 and expiry_date >= ?', current_date],
      :include => [:pictures],
      :order => "created_at DESC"
             
  end
  
  def self.get_user_products(id)
    query =  find_by_sql(["SELECT product_id,count(*)  as count FROM redemptions where user_id = ?  group by product_id",id])
    product = {}
    query.each do |q|
      product[q.product_id.to_i] = q.count
    end
    return product
  end
  
end
