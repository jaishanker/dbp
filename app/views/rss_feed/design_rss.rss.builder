xml.instruct! :xml, :version=>"1.0"
xml.rss(:version=>"2.0"){
  xml.channel{
    xml.title("SolidWorks - Design Central")
#    xml.link(@request.protocol + @request.host_with_port + url_for(:rss => nil))
    xml.description("")
    @designs.each do |design|
     xml.item do
       xml.title       design.name
       xml.link        url_for :only_path => false, :controller => 'designs', :action => 'design', :id => design.permalink
       xml.description get_name(design.description,250)
       xml.guid        url_for :only_path => false, :controller => 'designs', :action => 'design', :id => design.permalink
     end
   end
  }}


