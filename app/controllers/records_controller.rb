require 'record_importer'
class RecordsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :validate_authorization!
  skip_before_filter :verify_authenticity_token, :set_effective_date

  def create
    xml_file = request.body
    
    result = RecordImporter.import(xml_file)
    
    if (result[:status] == 'success') 
      @record = result[:record]
      QME::QualityReport.update_patient_results(@record.medical_record_number)
      Atna.log(current_user.username, :phi_import)
      Log.create(:username => current_user.username, :event => 'patient record imported', :medical_record_number => @record.medical_record_number)
    end

    render :text => result[:message], status: result[:status_code]
    
  end

  private
  
  def validate_authorization!
    authorize! :update, Record
  end

  
end