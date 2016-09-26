module Api

  class SessionsController < ApplicationController

    #before_filter :check_auth
    skip_before_filter :verify_authenticity_token

    respond_to :json

    def check_auth
      authenticate_or_request_with_http_basic do |username,password|
        resource = User.by_username(username)
        if resource.valid_password?(password)
          sign_in :user, resource
        end
      end
    end

  end

end