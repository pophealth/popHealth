class ApplicationController < ActionController::Base
  protect_from_forgery
  layout :layout_by_resource

  private

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
