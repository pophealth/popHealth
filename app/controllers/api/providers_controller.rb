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
    def index
      @providers = paginate(api_providers_url, Provider.alphabetical)
      authorize_providers(@providers)
      render json: @providers
    end
    
    api :GET, "/providers/:id", "Get an individual provider"
    param :id, String, :desc => "Provider ID", :required => true
    description <<-SDESC
      This will return an individual provider. It will include the id of its parent, if it
      has a parent. Children providers one level deep will be included in the children property
      if any children for this provider exist.
    SDESC
    example <<-EXAMPLE
      {"_id":"530f5d3eb99cc8f400000003",
        "address":"202 Burlington Rd.",
        "cda_identifiers":[{"_id":"530f5d3eb99cc8f400000004","extension":"518","root":"2.16.840.1.113883.4.6"}],
        "family_name":"McDaniels",
        "given_name":"Hiram",
        "level":null,
        "parent_id":"530f5d3eb99cc8f400000001",
        "children": [
          {"_id": "530f5d3eb99cc8f400000003", "address": "...", ...}
        ]
      }
    EXAMPLE
    def show
      provider_json = @provider.as_json
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