class LearningRequest < ActiveRecord::Base
  
#  validates_presence_of   :title,:message => "Title can't be blank"
  validates_presence_of   :topic,:message => "Topic can't be blank"
  validates_presence_of   :topic,:message => "Topic can't be blank"
  validates_presence_of   :user_id
#  validates_uniqueness_of :title,:case_sensitive => true
#  validates_length_of     :title, :within => 3..40, :message => "Title should be between 3 to 40 characters long"
  validates_length_of     :topic, :within => 3..40, :message => "Topic should be between 3 to 40 characters long"
#  validates_format_of     :title,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true,
                                             #:message =>"Title is not in proper format"
  validates_format_of     :topic,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true,
                                             :message =>"Topic is not in proper format"
  
  belongs_to :user
  attr_accessible :topic,:user_id,:captcha_solution, :captcha_secret
  has_captcha

  
end
