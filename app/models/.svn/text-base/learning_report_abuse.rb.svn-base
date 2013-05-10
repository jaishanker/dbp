
class LearningReportAbuse < ReportAbuse

  def after_save
      abuse_count(self.entity_id,self.type)
  end

  private
  def abuse_count(entity_id,type)
      total = ReportAbuse.count(:all,:conditions => ['entity_id = ? and type = ? ',entity_id ,type])
      if total >= 10
        learning = Learning.find_by_id(entity_id)
        learning.status = 2
        learning.save
      end
  end

end
