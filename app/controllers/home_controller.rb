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
    unless params[:effective_start_date].blank? || params[:effective_end_date].blank?
      month, day, year = params[:effective_start_date].split('/')
      user.effective_start_date = Time.gm(year.to_i, month.to_i, day.to_i).to_i
      month, day, year = params[:effective_end_date].split('/')
      user.effective_end_date = Time.gm(year.to_i, month.to_i, day.to_i).to_i
      user.save! 
    end

    start_date = current_user.effective_start_date
    end_date = current_user.effective_end_date

    rp = ReportingPeriod.where(start_date: start_date, end_date: end_date).first_or_create

    query = {
      'encounters' => {
        '$elemMatch' => { 
          '$or' => [
          {
            'start_time' => {'$lte' => end_date},
            'end_time' => {'$gte' => start_date}
          },
          {
            'time' => {'$lte' => end_date,'$gte' => start_date}
          }
          ]
        }
      }
    } 
    
    Record.where(query).each do |record|
      record.test_id = rp.id
      record.save!

    end
    
    render :json => :set_reporting_period, status: 200
  end

  private
  def validate_authorization!
    authorize! :read, HealthDataStandards::CQM::Measure
  end
end
