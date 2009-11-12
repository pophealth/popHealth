class UsersController < ApplicationController
  before_filter :find_user, :except => [:index]
  page_title 'Laika User Profile'

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:notice] = "Your settings have been saved."
      redirect_to edit_user_path(@user)
    else
      render :action => 'edit'
    end
  end

  private

  def find_user
    @user = current_user
  end
  
end
