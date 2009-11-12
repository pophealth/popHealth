class SettingsController < ApplicationController
  before_filter :require_admin, :except => :index
  page_title 'Configuration Settings'

  def index
    @settings = Setting.all :order => 'name ASC'
    if @settings.empty?
      flash[:notice] = %{
        There are no settings defined. This probably means that the Laika
        database needs to be re-seeded.
      }
    end
  end

  def update
    setting = Setting.find params[:id]
    setting.update_attributes params[:setting]

    flash[:notice] = "Updated #{setting}."
    redirect_to settings_url
  end

  private
  def require_admin
    if not current_user.administrator?
      flash[:notice] = 'You are not authorized to perform this operation.'
      redirect_to root_url
    end
  end
end

