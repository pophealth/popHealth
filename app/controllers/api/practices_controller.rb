module Api
  class PracticesController < ApplicationController
    resource_description do
      resource_id 'Admin::Practices'
      short 'Practices'
      formats ['json']
      description "This resource allows for the management of practices/organizations in the popHealth application."
    end
    before_filter :authenticate_user!
    before_filter :validate_authorization!
    skip_before_action :verify_authenticity_token

    api :GET, "/practices/:id", "Get the practice information"
    formats ['json']
    def show
      practice = Practice.find(params[:id])
      render :json => practice.as_json
    end
    
    api :GET, "/practices", "Get the practice information"
    formats ['json']
    def index
      practices = Practice.all
      render :json => practices.as_json
    end  
    
    private 

    def validate_authorization!
      authorize! :admin, :practices
      authorize! :admin, :providers
    end
  end
end
