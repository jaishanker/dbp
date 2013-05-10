module DesignsHelper
  
  def get_next_design_link(current_design_id)    
             current_design = Design.find(current_design_id)
             unless session[:design_owner].nil?
                designs = Design.my_designs(session[:design_owner])       
             end
             unless session[:category_id].nil?
                designs = Design.category_designs(session[:category_id])             
             end    
             unless session[:search_text].nil?
                designs = Design.search_all_designs(session[:search_text])             
             end                 
             unless session[:category_id].nil?
                unless session[:search_text].nil?
                    designs = Design.search_all_designs_for_categoy(session[:search_text],session[:category_id])      
                end
             end             
             if designs.nil?
                designs = Design.all_top_rated_designs
             end
             unless designs.nil?
                 for i in 0..designs.size-1
                   if designs[i] == current_design
                     unless designs[i+1].nil?
                       next_design = designs[i+1]
                     end
                   end
                 end
             end
              if next_design
                 link_to "",{ :controller => "designs", :action => "next_design", :permalink => next_design.permalink}, :class => "nextPage browse01 right", :style => "float:right;"
             end
   end
  
  def get_prev_design_link(current_design_id)    
             current_design = Design.find(current_design_id)
             unless session[:design_owner].nil?
                designs = Design.my_designs(session[:design_owner])       
             end
             unless session[:category_id].nil?
                designs = Design.category_designs(session[:category_id])             
             end    
             unless session[:search_text].nil?
                designs = Design.search_all_designs(session[:search_text])             
             end        
             unless session[:category_id].nil?
               unless session[:search_text].nil?
                   designs = Design.search_all_designs_for_categoy(session[:search_text],session[:category_id])            
               end
             end             
             if designs.nil?
                designs = Design.all_top_rated_designs
             end        
             unless designs.nil?
                 for i in 0..designs.size-1
                   if designs[i] == current_design
                     unless designs[i-1].nil?
                       prev_design = designs[i-1]
                     end
                   end
                 end
             end
             if prev_design
                 link_to "",{ :controller => "designs", :action => "prev_design", :permalink => prev_design.permalink}, :class => "nextPage browse01 left"
             end
  end
end
