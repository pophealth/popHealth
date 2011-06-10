class LogsController < ApplicationController
  before_filter :authenticate_user!
  
  # All attributes of the Log class are valid to sort on except ones that start with an underscore.
  VALID_SORTABLE_COLUMNS = Log.fields.keys.reject {|k| k[0] == '_'}
  VALID_SORT_ORDERS = ['desc', 'asc']
  
  def index
    order = []
    if VALID_SORTABLE_COLUMNS.include?(params[:sort]) && VALID_SORT_ORDERS.include?(params[:order])
      order << [params[:sort].to_sym, params[:order].to_sym]
    end

    # If no valid order is specified, order by date
    # If anything else is provided as a sort order, make date a secondary order
    if order.empty? || order[0][0] != :created_at
      order << [:created_at, :desc]
    end

    if current_user.admin?
      @logs = Log.order_by(order).paginate(:page => params[:page], :per_page => 20)
    else
      @logs = Log.where(:username => current_user.username).order_by(order).paginate(:page => params[:page], :per_page => 20)
    end
  end
end
