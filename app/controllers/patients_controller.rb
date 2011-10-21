class PatientsController < ApplicationController
  include MeasuresHelper

  before_filter :authenticate_user!
  load_resource exclude: %w{index}
  authorize_resource

  def index
  end

  def show
  end

  def validate_authorization!
    authorize! :read, Patient
  end

end