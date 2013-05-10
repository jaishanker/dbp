
class DesignReportAbuse < ReportAbuse

  def after_save
      abuse_count(self.entity_id,self.type)
  end

  private
  def abuse_count(entity_id,type)
      total = ReportAbuse.count(:all,:conditions => ['entity_id = ? and type = ? ',entity_id ,type])
      if total >= 10
        design = Design.find_by_id(entity_id)
        design.status = 2
        design.save
      end
  end


end
