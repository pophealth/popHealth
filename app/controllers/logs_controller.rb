class LogsController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :validate_authorization!
  add_breadcrumb 'Logs', '/logs'
  
  # All attributes of the Log class are valid to sort on except ones that start with an underscore.
  VALID_SORTABLE_COLUMNS = Log.fields.keys.reject {|k| k[0] == '_'}
  VALID_SORT_ORDERS = ['desc', 'asc']
  
  def index
#    order = []
#    if VALID_SORTABLE_COLUMNS.include?(params[:sort]) && VALID_SORT_ORDERS.include?(params[:order])
#      order << [params[:sort].to_sym, params[:order].to_sym]
#    end

    # If no valid order is specified, order by date
    # If anything else is provided as a sort order, make date a secondary order
#    if order.empty? || order[0][0] != :created_at
#      order << [:created_at, :asc]
#    end
    
    where = {}
 #   where[:username] = current_user.username unless current_user.admin?
    
    start_date = date_param_to_date(params[:log_start_date])
    end_date = date_param_to_date(params[:log_end_date])
    
    if start_date
      where[:created_at] = {'$gte' => start_date}
    end
    
    if end_date
      # will create an empty hash if created_at is nil or leave start_date alone if it is there
      where[:created_at] ||= {}
      where[:created_at].merge!('$lt' => end_date.next_day) # becomes less than midnight the next day
    end
        
    #added by ssiddiqui    
    event = params[:log_event]
    if event
    	where[:event] = event.to_s unless event.to_s == ""
    end
    
    @logs = Log.where(where).order_by(:created_at => :desc) #.where({:event=> "failed login attempt" }) #where(where) #.order_by(order) #paginate(:page => params[:page], :per_page => 20)
  end
  
  def delete_logs
  	Log.all.delete
  	render :action => :index
  end

	private
  
  def date_param_to_date(date_string)
    if date_string && date_string.split('/').length == 3
      split_date = date_string.split('/').map(&:to_i)
      Date.new(split_date[2], split_date[0], split_date[1])
    else
      nil
    end
  end
  
  def validate_authorization!
    authorize! :read, Log
  end
  
end
