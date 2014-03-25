module Api
  class ProvidersController < ApplicationController
    resource_description do
      short 'Providers'
      formats ['json']
      description <<-PRCDESC
        This resource allows for the management of providers in popHealth

        popHealth assumes that providers are in a hierarchy. This resource allows users
        to see the hierarchy of providers
      PRCDESC
    end
    include PaginationHelper
    # load resource must be before authorize resource
    load_resource except: %w{index create new}
    authorize_resource
    respond_to :json
    before_filter :authenticate_user!

    add_breadcrumb 'providers', :providers_url

    api :GET, "/providers", "Get a list of providers. Returns all providers that the user has access to."
    param_group :pagination, Api::PatientsController
    def index
      @providers = paginate(api_providers_url, Provider.order_by(["cda_identifiers.sortable_extension".to_sym, :asc]))
      authorize_providers(@providers)
      render json: @providers
    end

    api :GET, "/providers/:id", "Get an individual provider"
    param :id, String, :desc => "Provider ID", :required => true
    description <<-SDESC
      This will return an individual provider. It will include the id and name of its parent, if it
      has a parent. Children providers one level deep will be included in the children property
      if any children for this provider exist.
    SDESC
    example <<-EXAMPLE
      {
        _id: "530fc46575efe58027000019",
        address: "130 W. KINGSBRIDGE ROAD Bronx NY 10468-3904",
        cda_identifiers: [
          {
            _id: "530fc46575efe5802700001a",
            extension: "526",
            root: "2.16.840.1.113883.4.6"
          }
        ],
        family_name: null,
        given_name: "BRONX VA HOSPITAL",
        level: null,
        parent_id: "530fc46575efe58027000017",
        parent_ids: [
          "530fc46575efe58027000017"
        ],
        phone: null,
        specialty: null,
        team_id: null,
        title: null,
        parent_name: "VA NY/NJ Veterans Healthcare Network"
      }
    EXAMPLE
    def show
      provider_json = @provider.as_json
      provider_json[:parent_name] = Provider.find(@provider.parent_id).given_name if @provider.parent_id
      provider_json[:children] = @provider.children if @provider.children.present?
      render json: provider_json
    end

    api :POST, "/providers", "Create a new provider"
    def create
      @provider = Provider.create(params[:provider])
      render json: @provider
    end

    api :PUT, "/providers/:id", "Update a provider"
    param :id, String, :desc => "Provider ID", :required => true
    def update
      @provider.update_attributes!(params[:provider])
      render json: @provider
    end

    def new
      render json: Provider.new
    end

    api :DELETE, "/providers/:id", "Remove an individual provider"
    param :id, String, :desc => "Provider ID", :required => true
    def destroy
      @provider.destroy
      render json: nil, status: 204
    end

  private

    def authorize_providers(providers)
      providers.each do |p|
        authorize! :read, p
      end
    end
  end
end
