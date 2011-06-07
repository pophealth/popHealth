class LogsController < ApplicationController
  def index
    @logs = Log.paginate(:page => params[:page])
  end
end
