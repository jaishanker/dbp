xml.instruct! :xml, :version=>"1.0"
xml.rss(:version=>"2.0"){
  xml.channel{
    xml.title("SolidWorks - Learning Center")
#    xml.link(@request.protocol + @request.host_with_port + url_for(:rss => nil))
    xml.description("")
    @learnings.each do |learning|
     xml.item do
       xml.title       learning.title
       xml.link        url_for :only_path => false, :controller => 'learnings', :action => 'learning', :id => learning.permalink
       xml.description get_name(learning.description,250)
       xml.guid        url_for :only_path => false, :controller => 'learnings', :action => 'learning', :id => learning.permalink
     end
   end
  }}


