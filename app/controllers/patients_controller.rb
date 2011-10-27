class PatientsController < ApplicationController
  include MeasuresHelper

  before_filter :authenticate_user!
  before_filter :validate_authorization!

  def index
  end

  def show
    @patient = Record.find(params[:id])
  end

  def validate_authorization!
    authorize! :read, Record
  end

end