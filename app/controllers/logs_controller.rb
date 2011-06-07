class LogsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    if current_user.admin?
      @logs = Log.paginate(:page => params[:page], :per_page => 20)
    else
      @logs = Log.where(:username => current_user.username).paginate(:page => params[:page], :per_page => 20)
    end
  end
end
