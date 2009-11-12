class MessageLogsController < ApplicationController

  def index
    @message_logs = MessageLog.paginate(:all, :page => params[:page], :per_page => 3, :order => 'MESSAGEDATE DESC')
  end

end
