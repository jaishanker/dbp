# ActsAsCommentable
module Juixe
  module Acts #:nodoc:
    module Commentable #:nodoc:

      def self.included(base)
        base.extend ClassMethods  
      end

      module ClassMethods
        def acts_as_commentable
          has_many :comments, :as => :commentable, :dependent => :destroy, :order => 'created_at ASC'
          include Juixe::Acts::Commentable::InstanceMethods
          extend Juixe::Acts::Commentable::SingletonMethods
        end
      end
      
      # This module contains class methods
      module SingletonMethods
        # Helper method to lookup for comments for a given object.
        # This method is equivalent to obj.comments.
        def find_comments_for(obj)
          commentable = ActiveRecord::Base.send(:class_name_of_active_record_descendant, self).to_s
         
          Comment.find(:all,
            :conditions => ["commentable_id = ? and commentable_type = ?", obj.id, commentable],
            :order => "created_at DESC"
          )
        end
        
        # Helper class method to lookup comments for
        # the mixin commentable type written by a given user.  
        # This method is NOT equivalent to Comment.find_comments_for_user
        def find_comments_by_user(user) 
          commentable = ActiveRecord::Base.send(:class_name_of_active_record_descendant, self).to_s
          
          Comment.find(:all,
            :conditions => ["user_id = ? and commentable_type = ?", user.id, commentable],
            :order => "created_at DESC"
          )
        end
      end
      
      # This module contains instance methods
      module InstanceMethods
        # Helper method to sort comments by date
        def comments_ordered_by_submitted
          Comment.find(:all,
            :conditions => ["commentable_id = ? and commentable_type = ?", id, self.type.name],
            :order => "created_at DESC"
          )
        end
        
        # Helper method that defaults the submitted time.
        def add_comment(comment)
          comments << comment
        end

           # Check to see if a user already rated this rateable
        def commented_by_user?(user)
          rtn = false
          if user
            self.comments.each { |b|
              rtn = true if user.id == b.user_id
            }
          end
          rtn
        end

         def commenting_by_user(user)
          rtn = nil
          if user
            comments.each { |b|
              rtn = b if user.id == b.user_id
            }
          end
          rtn
        end
        
      end
      
    end
  end
end
