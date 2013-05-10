class Admin::HallOfFameController < ApplicationController
  
  before_filter :admin_login_required
  layout 'admin_layout'
  
  
  def index
    @hof = HallOfFame.find_all
  end
  
  def update_status    
    @hof = HallOfFame.find(params[:id])
    unless @hof.nil?
      @hof.status = params[:status]
      @hof.save
      message = "show_notice('Status updated successfully','success')"
    else
      message = "show_notice('Item not found','error')"
    end
    
    render :update do |page|
      page << message
    end
    
  end
  
  
  def view
    @hof = HallOfFame.find(params[:id])
    
    render :action => :view,:layout => false
    
  end
  
  def delete
    @hof  = HallOfFame.find(params[:id])
    @hof.update_attribute(:status,2)
    flash[:notice] = "You have successfully deleted hall of fame."
    redirect_to :action => "index"
  end
  
end
