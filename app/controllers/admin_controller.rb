class AdminController < ApplicationController
  before_filter :authenticate_user!
  before_filter :admin_user?
  
  def users
    @users = User.all
  end
  
  private
  
  def admin_user?
    redirect_to '/' unless current_user.admin?
  end
end
