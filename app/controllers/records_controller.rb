class RecordsController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def create_from_c32
    doc = Nokogiri::XML(params[:content])
    doc.root.add_namespace_definition('cda', 'urn:hl7-org:v3')
    patient = QME::Importer::PatientImporter.instance.parse_c32(doc)
    mongo['records'] << patient
    render :text => 'Patient imported', :status => 201
  end

  def import_json
    patient = JSON.parse(params[:content])
    mongo['records'] << patient
    render :text => 'Patient imported', :status => 201
  end

end