class AdminController < ApplicationController
  before_filter :authenticate_user!
  before_filter :admin_user?
  
  def users
    @users = User.all
  end
  
  def promote
    toggle_admin_privilidges(params[:username], :promote)
  end
  
  def demote
    toggle_admin_privilidges(params[:username], :demote)
  end
  
  def destroy
    user = User.first(:conditions => {:username => params[:username]})
    if user
      user.destroy
      render :text => "removed"
    else
      render :text => "User not found"
    end
  end
  
  def approve
    user = User.first(:conditions => {:username => params[:username]})
    if user
      user.update_attribute(:approved, true)
      render :text => "true"
    else
      render :text => "User not found"
    end
  end
  
  private
  
  def toggle_admin_privilidges(username, direction)
    user = User.first(:conditions => {:username => username})
    
    if user
      if direction == :promote
        user.update_attribute(:admin, true)
        render :text => "Yes - <span class=\"demote\" data-username=\"#{username}\">remove admin rights</span>"
      else
        user.update_attribute(:admin, false)
        render :text => "No - <span class=\"promote\" data-username=\"#{username}\">grant admin rights</span>"
      end

    else
      render :text => "User not found"
    end
  end
  
  def admin_user?
    redirect_to '/' unless current_user.admin?
  end
end
