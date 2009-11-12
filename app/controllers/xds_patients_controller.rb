class XdsPatientsController < ApplicationController
  page_title 'XDS Registry'

  # Creates the form that collects data to actuall provide and register a document to an XDS Repository
  def provide_and_register
    @patient = Patient.find(params[:id])
  end
  
  def do_provide_and_register
    pd = Patient.find(params[:pd_id])
    params[:metadata][:source_patient_info] = pd.source_patient_info

    md = XDS::Metadata.new
    md.from_hash(params[:metadata], AFFINITY_DOMAIN_CONFIG)

    md.unique_id = pd.generate_unique_id
    md.repository_unique_id = Setting.xds_repository_unique_id
    md.patient_id = pd.patient_identifier
    md.mime_type = 'text/xml'
    md.ss_unique_id = "1.3.6.1.4.1.21367.2009.1.2.1.#{Time.now.to_i}"
    md.source_id = "1.3.6.1.4.1.21367.2009.1.2.1"
    md.language_code = 'en-us'
    md.creation_time = Time.now.to_s(:brief)

    response = XDSUtils.provide_and_register(md, pd.to_c32)
    if response.success?
      flash[:notice] = "XDS Provide and Register successful."
    else
      flash[:error] = "XDS Provide and Register failed. #{response.errors.first[:code_context]}."
    end
    redirect_to patients_url
  end

end
