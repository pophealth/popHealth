module api
  class SessionsController < ApplicationController

    #before_filter :check_auth
    skip_before_filter :verify_authenticity_token

    respond_to :json
    
    /#def create
      build_resource

      userDetails= User.find_by_login(:login=>params[:user_login][:login])
      providerId = userDetails.provider_id

      logger.debug "Provider ID: " + providerId

      if (providerId) 
        resource = User.find_for_database_authentication(:login=>params[:username])
        store_location_for(resource, "/#providers/" + providerId) 
        return invalid_login_attempt unless resource

        if resource.valid_password?(params[:password])
          sign_in("user", resource)  
        end
        invalid_login_attempt
      else
        render :json=>{:success=>false, :message=>"user is missing provider id"}, :status=>422
      end

    end#/

    def check_auth
      authenticate_or_request_with_http_basic do |username,password|
        resource = User.find_by_email(username)
        if resource.valid_password?(password)
          sign_in :user, resource
        end
      end
    end
  end
end