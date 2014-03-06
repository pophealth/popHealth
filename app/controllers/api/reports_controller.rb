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
    param :effective_date, Fixnum, :desc => 'Time in seconds since the epoch for the end date of the reporting period',
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
                                   1356998340,
                                   end_date.years_ago(1),
                                   end_date, provider_filter), content_type: "attachment/xml"
    end

    private

    def generate_header(provider)
      header_hash = APP_CONFIG["cda_header"]
      header_hash[:identifier][:root] = UUID.generate

      header = Qrda::Header.new(header_hash)
      header.performers << provider
      header
    end
  end
end
