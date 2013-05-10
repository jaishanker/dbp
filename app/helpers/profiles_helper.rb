module ProfilesHelper
  
  def get_years(total_months)
    unless total_months.nil?
      if total_months > 251
        years = "More than 20"
      else        
         years = (total_months/12).to_i
      end
    else
      years = -1
    end
    years
  end
  
  def get_months(total_months)
    unless total_months.nil?
      if total_months > 251    
         months = 0        
       else
         months = total_months.to_i.remainder(12)  
      end
    else
      months = -1
    end
    months
  end    
  
  def get_link_to_object(requestable_type, object_id, request_id)
    if requestable_type == "Design"
       return link_to "View", {:controller => "designs", :action => "design", :permalink => object_id, :request_id => request_id}, :class => "grnbtn02"
    elsif requestable_type == "Learning"
       return link_to "View", {:controller => "learnings", :action => "learning", :permalink => object_id, :request_id => request_id}, :class => "grnbtn02"      
    elsif requestable_type == "Topic"
       return link_to "View", {:controller => "discussions", :action => "topic", :permalink => object_id, :request_id => request_id}, :class => "grnbtn02"   
    elsif requestable_type == "Game"
       return link_to "View", {:controller => "games", :action => "game", :permalink => object_id, :request_id => request_id}, :class => "grnbtn02"      
    elsif requestable_type == "News"
       return link_to "View", {:controller => "news", :action => "news", :permalink => object_id, :request_id => request_id}, :class => "grnbtn02"                           
    end
  end
end
