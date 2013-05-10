class Admin::BannerController < ApplicationController
  
  before_filter :admin_login_required
  layout 'admin_layout'
  
  
  def index
    @banner = Banner.find_all
  end
  
  def main
    @banner = Banner.new
  end
  
  def right
    @banner = Banner.new
    @banner.banner_page = ""
    @page = true
    render :action => "main.html.erb"
  end
  
  def create
    
    if params[:page] == "true"
    params[:banner][:banner_page] ||= []
    params[:banner][:banner_page] = getTags( params[:banner][:banner_page])
    end
    
    @banner = Banner.new(params[:banner])
    @banner.status = 1
    @banner.pictures.build(:photo => params[:photo]) if  params[:photo] 
    
    @banner.save
    if @banner.errors.empty?
      CACHE.delete("top_banner")
      CACHE.delete("right_banner")
      flash[:notice] = "Banner added successfully"
      redirect_to :action => :index
    else
      @page = true if params[:page] == "true"
      flash[:error] = "Errors occured while adding Banner"
      render :action => :main
    end
    
  end
  
  def update_status
    
    @banner = Banner.find(params[:id])
    unless @banner.nil?
      @banner.status = params[:status]
      @banner.save
      CACHE.delete("top_banner")
      CACHE.delete("right_banner")
      message = "show_notice('Status updated successfully','success')"
    else
      message = "show_notice('Item not found','error')"
    end
    
    render :update do |page|
      page << message
    end
    
  end
  
  def preview
    render :text => params[:value]
  end
  
  def view
    banner = Banner.find(params[:id])
    render :text => banner.banner_code
  end
  
end
