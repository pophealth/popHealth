class RecordsController < ApplicationController

  skip_before_filter :verify_authenticity_token
  before_filter :authenticate

  def create
    xml_file = params[:content].tempfile.read
    doc = Nokogiri::XML(xml_file)
    doc.root.add_namespace_definition('cda', 'urn:hl7-org:v3')
    patient = nil
    root_element_name = doc.root.name

    if root_element_name == 'ClinicalDocument'
      patient = QME::Importer::PatientImporter.instance.parse_c32(doc)
    elsif root_element_name == 'ContinuityOfCareRecord'
      if RUBY_PLATFORM =~ /java/
        ccr_importer = CCRImporter.instance
        patient_raw_json = ccr_importer.create_patient(xml_file)
        patient = JSON.parse(patient_raw_json)
      else
        render :text => 'CCR Support is currently disabled', :status => 500
      end
    else
      render :text => 'Unknown XML Format', :status => 400
    end

    if patient
      mongo['records'] << patient
      QME::QualityReport.destroy_all
      Atna.log(@user.username, :phi_import)
      Log.create(:username => @user.username, :event => 'Patient Record Imported', :patient_id => patient['patient_id'])
      render :text => 'Patient imported', :status => 201
    end
  end

  private

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      @user = User.first(:conditions => {:username => username})
      @user && @user.valid_password?(password)
    end
  end

end