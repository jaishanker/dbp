
class DiscussionReportAbuse < ReportAbuse

#   belongs_to :report_abuse

  def after_save
      abuse_count(self.entity_id,self.type)
  end

  private
  def abuse_count(entity_id,type)
      total = ReportAbuse.count(:all,:conditions => ['entity_id = ? and type = ? ',entity_id ,type])
      if total >= 10
        post = Post.find_by_id(entity_id)
        post.status = 2
        post.save
      end
  end
  
end
