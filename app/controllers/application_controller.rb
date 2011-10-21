class ApplicationController < ActionController::Base
  protect_from_forgery
  layout :layout_by_resource

  # lock it down!
  check_authorization :unless => :devise_controller?
  
  private

  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    '/logout.html'
  end

  def layout_by_resource
    if devise_controller?
      "users"
    else
      "application"
    end
  end
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  def mongo
    MONGO_DB
  end
end
