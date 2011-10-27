class RecordsController < ApplicationController

  skip_authorization_check
  skip_before_filter :verify_authenticity_token, :set_effective_date
  before_filter :authenticate

  def create
    xml_file = request.body
    doc = Nokogiri::XML(xml_file)
    doc.root.add_namespace_definition('cda', 'urn:hl7-org:v3')
    providers = []
    root_element_name = doc.root.name

    if root_element_name == 'ClinicalDocument'
      patient_data = QME::Importer::PatientImporter.instance.parse_c32(doc)
      providers = QME::Importer::ProviderImporter.instance.extract_providers(doc)
    elsif root_element_name == 'ContinuityOfCareRecord'
      if RUBY_PLATFORM =~ /java/
        ccr_importer = CCRImporter.instance
        patient_raw_json = ccr_importer.create_patient(xml_file)
        patient_data = JSON.parse(patient_raw_json)
      else
        render :text => 'CCR Support is currently disabled', :status => 500 and return
      end
    else
      render :text => 'Unknown XML Format', :status => 400 and return
    end

    @record = Record.create!(patient_data)
    
    providers.each do |pv|
      performance = ProviderPerformance.new(start_date: pv.delete(:start), end_date: pv.delete(:end), record: @record)
      provider = Provider.merge_or_build(pv)
      provider.save
      performance.provider = provider
      performance.save
    end
    
    QME::QualityReport.destroy_all
    Atna.log(@user.username, :phi_import)
    Log.create(:username => @user.username, :event => 'patient record imported', :patient_id => @record.patient_id)

    render :text => 'Patient imported', :status => 201
  end

  private

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      @user = User.first(:conditions => {:username => username})
      @user && @user.valid_password?(password)
    end
  end
  
end