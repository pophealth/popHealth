class HomeController < ApplicationController
  before_filter :authenticate_user!, :validate_authorization!

  def index
    # TODO base this on provider
    @patient_count = Record.count
    @categories = HealthDataStandards::CQM::Measure.categories([:lower_is_better, :type])
  end

  def check_authorization
    @provider = Provider.find(params[:id])
    auth = (can? :read, @provider) ? true : false
    render :json => auth.as_json
  end

  def set_reporting_period
    user = User.where(username: params[:username]).first
    unless params[:effective_from_date].blank? || params[:effective_to_date].blank?
      month, day, year = params[:effective_from_date].split('/')
      user.effective_from_date = Time.gm(year.to_i, month.to_i, day.to_i).to_i
      month, day, year = params[:effective_to_date].split('/')
      user.effective_to_date = Time.gm(year.to_i, month.to_i, day.to_i).to_i
      user.save! 
    end
    render :json => :set_reporting_period, status: 200
  end

  private
  def validate_authorization!
    authorize! :read, HealthDataStandards::CQM::Measure
  end
end
