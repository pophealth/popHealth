class HomeController < ApplicationController
  layout 'application_future'
  before_filter :authenticate_user!, :validate_authorization!
  
  def index
    @categories = HealthDataStandards::CQM::Measure.categories
  end

  private
  def validate_authorization!
    authorize! :read, HealthDataStandards::CQM::Measure
  end
end
