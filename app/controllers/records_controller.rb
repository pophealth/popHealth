class RecordsController < ActionController::Metal
  
  def create
    current_user = request.env['warden'].authenticate!
    
    if (current_user.admin?)
      result = HealthDataStandards::Import::BulkRecordImporter.import(request.body)

      if (result[:status] == 'success') 
        @record = result[:record]
        Atna.log(current_user.username, :phi_import)
        Log.create(:username => current_user.username, :event => 'patient record imported', :medical_record_number => @record.medical_record_number)
        QueryCache.delete_all
        PatientCache.delete_all
      end

      self.content_type = "text/plain"
      self.status = result[:status_code]
      self.response_body = result[:message]
    else
      self.content_type = "text/plain"
      self.status = 403
      self.response_body = "The user must be an admin user to create patients"
    end
    
  end
  
end