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
    
    api :GET, "/practices", "Get all practice information"
    formats ['json']
    def index
      practices = Practice.all
      render :json => practices.as_json
    end  
    
    api :POST, "/practices", "Create a practice"
    param :name, String, :desc => "Practice Name", :required => true
    param :organization, String, :desc => "Practice organization", :required => true
    param :user, String, :desc => "User to assign to practice", :required => false
    formats ['json']
    def create
      @practice = Practice.create(:name => params[:name], :organization => params[:organization])

      if @practice.save!
        identifier = CDAIdentifier.new(:root => "Organization", :extension => @practice.organization)
        provider = Provider.new(:given_name => @practice.name)
        provider.cda_identifiers << identifier
        provider.parent = Provider.root
        provider.save
        @practice.provider = provider
        
        if params[:user] != '' && params[:user]
          user = User.find(params[:user])
          @practice.users << user
          user.save
        end
        @practice.save!
      else
        @practice = nil
      end
      render :json => @practice
    end
    
    private 

    def validate_authorization!
      authorize! :admin, :practices
      authorize! :admin, :providers
    end
  end
end
