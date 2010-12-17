class ApplicationController < ActionController::Base
  protect_from_forgery
  
  private
  
  def mongo
    MONGO_DB
  end
end
