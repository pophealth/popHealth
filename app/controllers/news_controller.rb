class NewsController < ApplicationController
  before_filter :require_administrator, :except => :index
  page_title 'Laika News'

  def index
    @messages = SystemMessage.find :all, :order => 'created_at DESC', :limit => 30
  end

  def new
    @message = SystemMessage.new
  end

  def edit
    @message = SystemMessage.find params[:id]
  end

  def create
    @message = SystemMessage.new :body => params[:message][:body], :author => current_user
    @message.save!
    flash[:notice] = 'You have posted a new entry.'
    redirect_to :action => 'index'
  rescue ActiveRecord::RecordInvalid
    render :template => 'news/new'
  end

  def update
    @message = SystemMessage.find params[:id]
    @message.updater = current_user
    @message.update_attributes! params[:message]
    flash[:notice] = 'The post has been updated.'
    redirect_to :action => 'index'
  rescue ActiveRecord::RecordInvalid => e
    render :template => 'news/edit'
  end

  def destroy
    message = SystemMessage.find params[:id]
    if message
      message.destroy
      flash[:notice] = "You have deleted the post."
    end
    redirect_to :action => 'index'
  end

end

