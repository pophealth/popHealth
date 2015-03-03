class HomeController < ApplicationController
  before_filter :authenticate_user!, :validate_authorization!

  def index
    # TODO base this on provider
    @patient_count = Record.count
    @categories = HealthDataStandards::CQM::Measure.categories([:lower_is_better, :type])
  end

  def set_reporting_period
    user = User.where(username: params[:username]).first
    unless params[:effective_date] == nil || params[:effective_date] == '' 
      month, day, year = params[:effective_date].split('/')
      effective_date = Time.gm(year.to_i, month.to_i, day.to_i).to_i
      user.effective_date = effective_date
      user.save! 
    end
    render :json => :set_reporting_period
  end

  private
  def validate_authorization!
    authorize! :read, HealthDataStandards::CQM::Measure
  end
end
