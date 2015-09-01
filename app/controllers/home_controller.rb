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
    unless params[:effective_date] == nil || params[:effective_date] == '' 
      month, day, year = params[:effective_date].split('/')
      if year.length == 2
        year = "20" + year
      end
      begin
        effective_date = Time.gm(year.to_i, month.to_i, day.to_i).to_i
      rescue
        render :json => :set_reporting_period, status: 200
      end
      user.effective_date = effective_date
      user.save!
    end
    render :json => :set_reporting_period, status: 200
  end

  private
  def validate_authorization!
    authorize! :read, HealthDataStandards::CQM::Measure
  end
end
