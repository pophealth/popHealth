class ApplicationController < ActionController::Base
  protect_from_forgery
  layout :layout_by_resource

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

  def mongo
    MONGO_DB
  end
end
