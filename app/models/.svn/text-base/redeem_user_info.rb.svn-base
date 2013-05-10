class RedeemUserInfo < ActiveRecord::Base
  belongs_to :redemption
  belongs_to :user
  
  validates_presence_of     :address_line1, :message => "Address Line1 can't be blank", :if => Proc.new { |user| user.shipment_type  == 0 }
  validates_presence_of     :state, :message => "State can't be blank", :if => Proc.new { |user| user.shipment_type  == 0 }
  validates_presence_of     :city, :message => "City can't be blank", :if => Proc.new { |user| user.shipment_type  == 0 }
  validates_presence_of     :mob_no, :message => "Mobile Number can't be blank"
  validates_numericality_of       :pincode, :message => "Pincode should contain only numbers", :allow_nil => true
  validates_format_of :tel_no,
    :message => "Contact no must be a valid telephone number",
    :with => /^[\(\)0-9\- \+\.]{10,20} *[extension\.]{0,9} *[0-9]{0,5}$/i, :allow_nil => true, :allow_blank => true   
 validates_format_of :mob_no,
    :message => "Contact no must be a valid mobile number",
    :with => /^[\(\)0-9\- \+\.]{10,20} *[extension\.]{0,9} *[0-9]{0,5}$/i, :allow_nil => true, :allow_blank => true     
  
  
end