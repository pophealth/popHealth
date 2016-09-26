module Api

  class SessionsController < ApplicationController

    #before_filter :check_auth
    skip_before_filter :verify_authenticity_token

    respond_to :json

    def check_auth
      authenticate_or_request_with_http_basic do |username,password|
        resource = User.by_username(username)
        return invalid_login_attempt unless resource

        if resource.valid_password?(password)
          sign_in :user, resource

          if (providerId) 
            store_location_for(resource, "/#providers/" + providerId) 
          else
            render :json=>{:success=>false, :message=>"User is missing provider id"}, :status=>422
          end

        end

      end
      
    end

    def invalid_login_attempt
      render :json=> {:success=>false, :message=>"Error with your login or password"}, :status=>401
    end

  end

end