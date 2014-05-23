module Api

  class ReportsController < ApplicationController
    resource_description do
      short 'Reports'
      formats ['xml']
      description <<-RCDESC
        This resource is responsible for the generation of QRDA Category III reports from clincial
        quality measure calculations.
      RCDESC
    end
    before_filter :authenticate_user!
    skip_authorization_check

    api :GET, '/reports/qrda_cat3.xml', "Retrieve a QRDA Category III document"
    param :measure_ids, Array, :desc => 'The HQMF ID of the measures to include in the document', :required => false
    param :effective_date, String, :desc => 'Time in seconds since the epoch for the end date of the reporting period',
                                   :required => false
    param :provider_id, String, :desc => 'The Provider ID for CATIII generation'
    description <<-CDESC
      This action will generate a QRDA Category III document. If measure_ids and effective_date are not provided,
      the values from the user's dashboard will be used.
    CDESC
    def cat3
      measure_ids = params[:measure_ids] ||current_user.preferences["selected_measure_ids"]
      filter = measure_ids=="all" ? {}  : {:hqmf_id.in =>measure_ids}
      exporter =  HealthDataStandards::Export::Cat3.new
      effective_date = params["effective_date"] || current_user.effective_date || Time.gm(2012, 12, 31)
      end_date = Time.at(effective_date.to_i)
      provider = provider_filter = nil
      if params[:provider_id].present?
        provider = Provider.find(params[:provider_id])
        provider_filter = {}
        provider_filter['filters.providers'] = params[:provider_id] if params[:provider_id].present?
      end
      render xml: exporter.export(HealthDataStandards::CQM::Measure.top_level.where(filter),
                                   generate_header(provider),
                                   effective_date.to_i,
                                   end_date.years_ago(1),
                                   end_date, provider_filter), content_type: "attachment/xml"
    end

    api :GET, "/reports/cat1/:id/:measure_ids"
    formats ['xml']
    param :id, String, :desc => "Patient ID", :required => true
    param :measure_ids, String, :desc => "Measure IDs", :required => true
    param :effective_date, String, :desc => 'Time in seconds since the epoch for the end date of the reporting period',
                                   :required => false
    description <<-CDESC
      This action will generate a QRDA Category I Document. Patient ID and measure IDs (comma separated) must be provided. If effective_date is not provided,
      the value fromt he user's dashboard will be used.
    CDESC
    def cat1
      exporter = HealthDataStandards::Export::Cat1.new
      patient = Record.find(params[:id])
      measure_ids = params["measure_ids"].split(',')
      measures = HealthDataStandards::CQM::Measure.where(:hqmf_id.in => measure_ids)
      end_date = params["effective_date"] || current_user.effective_date || Time.gm(2012, 12, 31)
      start_date = end_date.years_ago(1)
      render xml: exporter.export(patient, measures, start_date, end_date)
    end


    private

    def generate_header(provider)
      header = Qrda::Header.new(APP_CONFIG["cda_header"])

      header.identifier.root = UUID.generate
      header.authors.each {|a| a.time = Time.now}
      header.legal_authenticator.time = Time.now
      header.performers << provider

      header
    end
  end
end
