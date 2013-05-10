class Admin::NewsRssController < ApplicationController
  
  before_filter :admin_login_required
  layout 'admin_layout'
  
  def index
    @rss = NewsRss.find_all
    @news_rss = NewsRss.new    
  end
  
  def update_status
    
    @news_rss = NewsRss.find(params[:id])
    
    unless @news_rss.nil?
      @news_rss.status = params[:status]
      @news_rss.save
      
      message = "show_notice('Status updated successfully','success')"
    else
      message = "show_notice('Item not found','error')"
    end
    
    render :update do |page|
      page << message
    end
    
  end
  
  
  def create
    @news_rss = NewsRss.new(params[:news_rss])
    @news_rss.status = 1
    @news_rss.save
    
    render :update do |page|
      if @news_rss.errors.empty?
        flash[:notice] = "News Rss created successfully"
        page.redirect_to "/admin/news_rss" 
        
      else
        page.visual_effect  :appear,"error"
        page.replace_html :error,
        :partial => '/layouts/errors'
        page << "show_notice('Errors occured while creating news rss','error')"
     
        
        page.delay(10) do
          page.visual_effect  :fade,"error"
        end
        
      end
    end
  end
  
  
  def delete
    
    @news_rss = NewsRss.find_by_id(params[:id])
    @news_rss.destroy unless @news_rss.nil?
    flash[:notice] = "News Rss deleted successfully"
    redirect_to :back
    
  end
  
  private
  
  def check_login
    unless logged_in?
      flash[:error] = "Please login first"
      redirect_to "/" and return
    end
  end
  
  
end
