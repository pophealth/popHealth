class PatientsController < ApplicationController
  include MeasuresHelper

  before_filter :authenticate_user!
  before_filter :set_up_environment

  def index
  
  end
  
  def show
    patient_id = params[:id]
    @records = mongo['patient_cache'].find({'value.patient_id' => BSON::ObjectId(patient_id)}).to_a #,
#                                      {:sort => [sort, sort_order], :skip => @skip, :limit => @limit}).to_a
#raise (@records.first.inspect)
    render 'patient'
  end
  
  
    def set_up_environment
      #~ @patient_count = mongo['records'].count
      #~ if current_user && current_user.effective_date
        #~ @effective_date = current_user.effective_date
      #~ else
        #~ @effective_date = Time.gm(2010, 12, 31).to_i
      #~ end
      #~ @period_start = MeasuresController.three_months_prior(@effective_date)
      #~ if params[:id]
        #~ @quality_report = QME::QualityReport.new(params[:id], params[:sub_id], 'effective_date' => @effective_date)
        #~ @measure = QME::QualityMeasure.new(params[:id], params[:sub_id])
      #~ end

    end
  
end