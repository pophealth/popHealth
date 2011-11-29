class AdminController < ApplicationController

  before_filter :authenticate_user!
  before_filter :validate_authorization!
#  add_breadcrumb 'admin', :admin_users_path

  def users
    @users = User.all
  end

  def promote
    toggle_admin_privilidges(params[:username], :promote)
  end

  def demote
    toggle_admin_privilidges(params[:username], :demote)
  end

  def disable
    user = User.by_username(params[:username]);
    disabled = params[:disabled].to_i == 1
    if user
      user.update_attribute(:disabled, disabled)
      if (disabled)
        render :text => "<a href=\"#\" class=\"disable\" data-username=\"#{user.username}\">disabled</span>"
      else
        render :text => "<a href=\"#\" class=\"enable\" data-username=\"#{user.username}\">enabled</span>"
      end
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
    user = User.by_username username

    if user
      if direction == :promote
        user.update_attribute(:admin, true)
        render :text => "Yes - <a href=\"#\" class=\"demote\" data-username=\"#{username}\">remove admin rights</a>"
      else
        user.update_attribute(:admin, false)
        render :text => "No - <a href=\"#\" class=\"promote\" data-username=\"#{username}\">grant admin rights</a>"
      end
    else
      render :text => "User not found"
    end
  end

  def validate_authorization!
    authorize! :admin, :users
  end
end