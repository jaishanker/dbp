class Admin::ProductsController < ApplicationController
  
  before_filter :admin_login_required
  before_filter :top_count,:only => [:index,:category,:report]
  layout 'admin_layout'
  require 'spreadsheet/excel'  
  
  def index
    @product = Product.find_all
    session[:product] = @product
  end
  
  
  def new
    @product = Product.new
  end
  
  
  def create
    @product = Product.new(params[:product])
    @product.pictures.build(:photo => params[:photo])
    @product.products_available = params[:product][:product_count].to_i
    @product.status = 1
    @product.save
    if @product.errors.empty?
      flash[:notice] = "Product added successfully"
      redirect_to :action => :index
    else
      flash[:error] = "Errors occured while adding Product"
      render :action => :new
    end
    
  end
  
  
  def update_status
    
    @product = Product.find(params[:id])
    unless @product.nil?
      @product.status = params[:status]
      @product.save
      
      message = "show_notice('Status updated successfully','success')"
    else
      message = "show_notice('Item not found','error')"
    end
    
    render :update do |page|
      page << message
    end
    
  end
  
  
  def category
    @product_category = ProductCategory.new
    @categories = ProductCategory.find_all
  end
  
  
  def category_create
    @product_category = ProductCategory.new(params[:product_category])
    @product_category.status = 1
    @product_category.save
    
    render :update do |page|
      if @product_category.errors.empty?
        flash[:notice] = "Category created successfully"
        page.redirect_to "/admin/news/category" 
        
      else
        page.visual_effect  :appear,"error"
        page.replace_html :error,
          :partial => '/layouts/errors'
        page << "show_notice('Errors occured while creating category','error')"
        page << "addError('news_category_name')"
        
        page.delay(10) do
          page.visual_effect  :fade,"error"
        end
        
      end
    end
  end
  
  
  def update_cat_status
    
    @product_category = ProductCategory.find(params[:id])
    unless @product_category.nil?
      @product_category.status = params[:status]
      @product_category.save
      
      
      # updating the news status according to category status
      # when category is deleted the status is updated to 3
      if params[:status] == "1"
        @product_category.news.update_all("status = 1","status = 3")
        @product_category.news.collect{|d| d.comments.update_all("status = 1","status = 3") }   
        @product_category.news.collect{|d| d.requests.update_all("status = 1","status = 3") }                 
      else
        @product_category.news.update_all("status = 3", "status = 1")
        @product_category.news.collect{|d| d.comments.update_all("status = 3","status = 1") }   
        @product_category.news.collect{|d| d.requests.update_all("status = 3","status = 1") }                
      end
      
      # end 
      
      
      
      message = "show_notice('Category status updated successfully','success')"
    else
      message = "show_notice('Category not found','error')"
    end
    
    render :update do |page|
      page << message
    end
    
  end
  
  
  def delete_category
    
    @product_category = ProductCategory.find(params[:id])
    @product_category.destroy unless @product_category.nil?
    flash[:notice] = "Category deleted successfully"
    redirect_to :back
    
  end
  
  
  def download
    
    @product = session[:product] ||  Product.find_all
    
    filepath="Product_Report_#{Time.now.utc.strftime('%Y-%d-%m')}.xls"
    workbook=Spreadsheet::Excel.new("#{RAILS_ROOT}/public/report/#{filepath}")
    worksheet=workbook.add_worksheet("Product Details")
    
    worksheet.write(0, 0,"Total " + @product.length.to_s + " products")
    
    worksheet.write(2, 0, "Index")
    worksheet.write(2, 1, "Name")
    worksheet.write(2, 2, "Description")    
    worksheet.write(2, 3, "Expiry Date")
    worksheet.write(2, 4, "Product Count")
    worksheet.write(2, 5, "Points Required")
    worksheet.write(2, 6, "Shipment Cost")    
    worksheet.write(2, 7, "Products Available")
    
    
    row = 4
    @product.each_with_index do |n,i|
      worksheet.write(row, 0, i + 1)
      worksheet.write(row, 1, n.title)
      worksheet.write(row, 2, n.description)      
      worksheet.write(row, 3, n.expiry_date.strftime("%d %b %Y"))
      worksheet.write(row, 4, n.product_count)
      worksheet.write(row, 5, n.points_required )
     worksheet.write(row, 6, n.shipment_cost)      
      worksheet.write(row, 7, n.products_available)
      row += 1
    end
    workbook.close
    
    send_file RAILS_ROOT + "/public/report/" + filepath
    
    
  end
  
  
  def report
    
    if params[:id]
      @product = Product.find_by_id(params[:id])
      @product_name = @product.title
      @product_id = @product.id
      session[:title] = "Product  - " + @product_name + " Report"
      @views_count = @product.view_count
      @comments_count = ProductComment.get_count_for_news(@product_id)
    else
      session[:title] = "Product  - General Report"
    end
    
    
    
    case params[:duration]
      when "2 Weeks"
      
      session[:duration] = "Last Two Weeks"
      start_date = Date.today.at_beginning_of_week.advance(:weeks => -1)
      split = 'next'
      format = "%d %a"
      query_format = "%Y-%m-%d"
      group = 'date'
      
      when "Month"
      
      session[:duration] = "This Month"
      start_date = Date.today.at_beginning_of_month
      split = 'next_week'
      format = "%d %a"
      query_format = "%W"
      group = 'week'
      
      when "2 Months"
      
      session[:duration] = "Last Two Months"
      start_date = Date.today.at_beginning_of_month.advance(:months => -1)
      split = 'next_week'
      format = "%d %a"
      query_format = "%W"
      group = 'week'
      
      when "3 Months"
      
      session[:duration] = "Last 3 Months"
      start_date = Date.today.at_beginning_of_month.advance(:months => -2)
      split = 'next_month'
      format = "%B"
      query_format = "%m"
      group = 'month'
      
      when "6 Months"
      
      session[:duration] = "Last 6 Months"
      start_date = Date.today.at_beginning_of_month.advance(:months => -5)
      split = 'next_month'
      format = "%B"
      query_format = "%m"
      group = 'month'
      
      when "Year"
      
      session[:duration] = "This Year"
      start_date = Date.today.at_beginning_of_year
      split = 'next_month'
      format = "%B"
      query_format = "%m"
      group = 'month'
      
    else
      params[:duration] = "Week"
      session[:duration] = "This Week"
      start_date = Date.today.at_beginning_of_week
      split = 'next'
      format = "%d %a"
      query_format = "%Y-%m-%d"
      group = 'date'
      
    end
    @start_date = start_date
    logger.info "--------------------------"
    
    
    session[:type] = params[:type] || 'View'
    
    if params[:id]
      case params[:type]
        when "View"
        values = View.get_single_reporting_values(@start_date,'Product',group,@product_id)
        when "Comment"
        values = Comment.get_single_reporting_values(@start_date,'Product',group,@product_id)
      else
      end
    else
      case params[:type]
        when "View"
        values = View.get_reporting_values(@start_date,'Product',group)
        when "Comment"
        values = Comment.get_reporting_values(@start_date,'Product',group)
      else
      end
    end
    
    
    @values = {}
    unless values.nil?
      values.each do |val|
        if query_format == "%m"
          @values[val.splitter.length == 2 ? val.splitter.to_s : '0' + val.splitter.to_s] = val.count
        else
          @values[val.splitter] = val.count
        end
        
      end
    end
    logger.info "----------------------"
    logger.info @values.inspect
    
    @output = {}
    
    i = 0
    while start_date <= Date.today
      logger.info "==========" + start_date.strftime(query_format)
      if query_format == "%W"
        @output[start_date.strftime(format) + "-" + start_date.advance(:days => 6).strftime(format) ] = [ i, @values[start_date.strftime(query_format)].nil? ? 0 : @values[start_date.strftime(query_format)]]
      else
        @output[start_date.strftime(format)] = [ i, @values[start_date.strftime(query_format)].nil? ? 0 : @values[start_date.strftime(query_format)]]
      end
      
      start_date = eval("start_date." + split)
      i = i + 1
    end
    
    logger.info @output.sort{|a,b| a[1][0]<=>b[1][0]}.inspect
    
    session[:output] = @output.sort{|a,b| a[1][0]<=>b[1][0]}
    # render :text => @output.inspect
    
  end
  
  
  def get_xml
    
    respond_to do |format|
      format.xml
    end
    
  end
  
  def redemptions
    @product = Product.find(params[:id])
    @redemptions = @product.redemptions
  end
  
  def download_redemption
    unless params[:id].nil?
        @product = Product.find(params[:id])
        @redemptions = @product.redemptions
    else
        @redemptions = Redemption.all      
    end    
    filepath="Redemption_Report_#{Time.now.utc.strftime('%Y-%d-%m')}.xls"
    workbook=Spreadsheet::Excel.new("#{RAILS_ROOT}/public/report/#{filepath}")
    worksheet=workbook.add_worksheet("Redempion Details")
    
    worksheet.write(0, 0,"Total " + @redemptions.length.to_s + " redemptions")
    
    worksheet.write(2, 0, "Index")
    worksheet.write(2, 1, "Product Name")
    worksheet.write(2, 2, "Redeemed By")    
    worksheet.write(2, 3, "Points Redeemed")
    worksheet.write(2, 4, "Address Line1")
    worksheet.write(2, 5, "Address Line2")
    worksheet.write(2, 6, "Country")
    worksheet.write(2, 7, "State")
    worksheet.write(2, 8, "City")
    worksheet.write(2, 9, "Pincode")   
    worksheet.write(2, 10, "Telephone No")         
    worksheet.write(2, 11, "Mobile No")               
    worksheet.write(2, 12, "Shipment Asked?")         
    worksheet.write(2, 13, "Approved?")     
    worksheet.write(2, 14, "Shifted?")         
    
    row = 4
    @redemptions.each_with_index do |n,i|
      redemption_user_info = RedeemUserInfo.find_by_redemption_id(n.id)  
      worksheet.write(row, 0, i + 1)
      worksheet.write(row, 1, n.product.title)
      worksheet.write(row, 2, n.user.login)      
      worksheet.write(row, 3, n.points)
      worksheet.write(row, 4, redemption_user_info.address_line1)
      worksheet.write(row, 5, redemption_user_info.address_line2 )
      worksheet.write(row, 6, redemption_user_info.country )
      worksheet.write(row, 7, redemption_user_info.state )      
      worksheet.write(row, 8, redemption_user_info.city )      
      worksheet.write(row, 9, redemption_user_info.pincode )           
      worksheet.write(row, 10, redemption_user_info.tel_no )           
      worksheet.write(row, 11, redemption_user_info.mob_no )      
      if redemption_user_info.shipment_type == 0
          worksheet.write(row, 12, 'Yes' )              
      else
          worksheet.write(row, 12, 'No' )                      
      end
      if n.approved == 1
          worksheet.write(row, 13, 'Yes' )              
      else
          worksheet.write(row, 13, 'No' )                      
      end
      if n.shifted == 1
          worksheet.write(row, 14, 'Yes' )              
      else
          worksheet.write(row, 14, 'No' )                      
      end      
      row += 1
    end
    workbook.close
    
    send_file RAILS_ROOT + "/public/report/" + filepath
    
    
  end  
  
  def all_redemptions
       @redemptions = Redemption.all
  end
  
  def user_details
    @redemption_user_info = RedeemUserInfo.find(params[:id])
    render :layout => false    
  end
  
  def update_redemption_status    
    @redemption = Redemption.find(params[:id])
    unless @redemption.nil?
      @redemption.status = params[:status]
      @redemption.save      
      message = "show_notice('Status updated successfully','success')"
    else
      message = "show_notice('Item not found','error')"
    end  
    render :update do |page|
      page << message
    end    
  end
  
  def update_shipment_status    
    @redemption = Redemption.find(params[:id])
    unless @redemption.nil?
      @redemption.shifted = params[:shifted]
      @redemption.save      
     UserMailer.deliver_shipment_notification(@redemption)           
      message = "show_notice('Shipment status updated successfully','success')"
    else
      message = "show_notice('Item not found','error')"
    end  
    render :update do |page|
      page << message
    end    
  end  
  
  def approve
    @redemption = Redemption.find(params[:id])
    redemption_user_info = RedeemUserInfo.find_by_redemption_id(@redemption.id)     
    product = @redemption.product
    user = @redemption.user
    unless @redemption.nil?
      @redemption.approved = 1
      @redemption.save     
      product.products_available -= 1
      product.save
      user.points -= product.points_required
      if redemption_user_info.shipment_type == 0
         user.points -= product.shipment_cost.to_i        
      end
      user.save    
      UserMailer.deliver_redemption_approval_notification(@redemption)             
      message = "show_notice('Redemption approved successfully','success')"
    else
      message = "show_notice('Item not found','error')"
    end      
    render :update do |page|
      page << message
      page.replace_html "approve_link_#{@redemption.id}", "Approved"
    end    
  end
  
  private
  
  def check_login
    unless logged_in?
      flash[:error] = "Please login first"
      redirect_to "/" and return
    end
  end
  
  def top_count
    @product_count = Product.count
    
  end
  
end
