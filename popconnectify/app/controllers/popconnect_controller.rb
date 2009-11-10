class PopconnectController < ApplicationController

  def index

  end

  def upload
     render :layout => false
  end

  def patient_record_save
    PatientC32Importer.import_c32(ClinicalDocument.create!(params[:clinical_document]).as_xml_document)
    redirect_to :controller => 'popconnect'
  end

end