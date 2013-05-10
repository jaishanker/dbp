class ShareController < ApplicationController
     log_activity_streams :current_user, :login, "shared", 
        :@obj, :user_id,:share_with_followings, :shared_with_followings, {:total => 1,:indirect_object => :@obj_owner,:indirect_object_name_method => :login,:indirect_object_phrase => 'owns_this_object' }   
    log_activity_streams :current_user, :login, "shared", 
        :@obj, :user_id,:share_with_followers, :shared_with_followers, {:total => 1,:indirect_object => :@obj_owner,:indirect_object_name_method => :login,:indirect_object_phrase => 'owns_this_object' }   
     log_activity_streams :current_user, :login, "favorited", 
        :@obj, :user_id,:add_to_favorite, :added_to_favorite, {:total => 1,:indirect_object => :@obj_owner,:indirect_object_name_method => :login,:indirect_object_phrase => 'owns_this_object' }   
#    log_activity_streams :current_user, :login, "removed from favorite", 
#        :@obj, :user_id,:remove_from_favorite, :removed_from_favorites, {:total => 1 }   
      
  def share_with_followings    
    @suppress_activity_stream = true
     @obj = params[:type].constantize.find(params[:id])
     @obj_owner = @obj.user
#    if params[:all_following] == '1'
      unless current_user.following_by_type('User').empty?
                  @suppress_activity_stream = false
      end
      for followee in current_user.following_by_type('User')
           @obj.share_to(followee,current_user)
           request = Request.find_by_sender_id_and_recipient_id_and_requestable_id_and_requestable_type(current_user.id,followee.id,@obj.id,params[:type])
           if request.nil?
              Request.create(:sender_id => current_user.id, :recipient_id => followee.id, :requestable_type=> params[:type], :requestable_id=> @obj.id, :status => "pending")
           end
      end
#    end
    
    respond_to do |format|
      format.html
      format.js {
        render :update do |page| 
          unless current_user.following_by_type('User').empty?
              message = "show_notice('Successfully shared','success')"
              page << message 
          else
              message = "show_notice('You are not following anybody yet','error')"
              page << message 
          end
        end
      }
    end     
    
  end
  
  def share_with_followers
    @suppress_activity_stream = true
    @obj = params[:type].constantize.find(params[:id])
     @obj_owner = @obj.user    
    user_followers = current_user.followers
    unless user_followers.empty?
           @suppress_activity_stream = false
    end    
#    if params[:all_followers] == '1'
      for follower in user_followers
           @obj.share_to(follower,current_user)
           request = Request.find_by_sender_id_and_recipient_id_and_requestable_id_and_requestable_type(current_user.id,follower.id,@obj.id,params[:type])
           if request.nil?
              Request.create(:sender_id => current_user.id, :recipient_id => follower.id, :requestable_type=> params[:type], :requestable_id=> @obj.id, :status => "pending")
           end
      end
#    end    
    respond_to do |format|
      format.html
      format.js {
        render :update do |page| 
          unless user_followers.empty?
              message = "show_notice('Successfully shared','success')"
              page << message
          else
              message = "show_notice('You dont have any followers yet','error')"
              page << message
          end
        end
      }
    end     
  end  
  
  def add_to_favorite
    @suppress_activity_stream = true
    if enough_points?(FAVORITED)
        @obj = params[:type].constantize.find(params[:id])
        @obj_owner = @obj.user
        if current_user.has_favorite?(@obj)
           flash[:notice] = "You have already added this to favourite"
        else
           current_user.has_favorite(@obj)
           @obj.user.add_points(FAVORITED, "favorite_received", @obj)
           current_user.substract_points(FAVORITED, "favorite_given", @obj)       
           @suppress_activity_stream = false
           flash[:notice] = "Succesfully added to favorites"
           if params[:type] == "Design"
              if @obj.user.subscribe == 1
                 @obj.user.notify_favorite_received(current_user,@obj)
              end
           end
        end

        render :update do |page|
           session[:flag] = true
#            page.redirect_to(:back)
              page.reload
        end
    else
        flash[:error] = "You dont have enough points to do this action"      
        render :update do |page|
           session[:flag] = true     
#          page.redirect_to(:back)    
            page.reload
        end
     end
  end

  def remove_from_favorite
        @obj =  params[:type].constantize.find(params[:id])
        current_user.has_no_favorite(@obj)
        @obj.user.actual_substract_points(FAVORITED,"unfavorited_by_#{current_user.login}",@obj)       
        current_user.actual_substract_points(FAVORITED,"unfavorited_#{@obj.user.login}'s_object",@obj)        
        flash[:notice] = "Succesfully removed from favorites"
        render :update do |page|
          session[:flag] = true
          page.reload
#          page.redirect_to(:back)
        end
  end  
  
end
