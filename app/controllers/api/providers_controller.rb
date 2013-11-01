  module Api
  class ProvidersController < ApplicationController
    include PaginationHelper
    # load resource must be before authorize resource
    load_resource except: %w{index create new}
    authorize_resource
    respond_to :json
    before_filter :authenticate_user!
    
    add_breadcrumb 'providers', :providers_url
    
    def index
      @providers = paginate(api_providers_url, Provider.alphabetical)
      authorize_providers(@providers)
      render json: @providers
    end
    
    def show
      render json: @provider
    end

    def create
      @provider = Provider.create(params[:provider])
      render json: @provider
    end
    
    def update
      @provider.update_attributes!(params[:provider])
      render json: @provider
    end

    def new
      render json: Provider.new
    end
   
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