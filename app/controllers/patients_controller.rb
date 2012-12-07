class PatientsController < ApplicationController
  include MeasuresHelper

  before_filter :authenticate_user!
  before_filter :validate_authorization!
  before_filter :load_patient, :only => [:show, :toggle_excluded]
  after_filter :hash_document, :only => :list
  
  add_breadcrumb_dynamic([:patient], only: %w{show}) {|data| patient = data[:patient]; {title: "#{patient.last}, #{patient.first}", url: "/patients/show/#{patient.id}"}}

  def show

    respond_to do |wants|
      wants.html {}
      wants.json do
        @outliers = []
        @measures = Measure.list
        @measures.each do |measure|
          executor = QME::MapReduce::Executor.new(measure['id'], measure['sub_id'], {'effective_date' => @effective_date})
          result = executor.get_patient_result(@patient.medical_record_number)
          if result['antinumerator']
            @outliers << measure
          end
        end

        @manual_exclusions = ManualExclusion.for_record(@patient).all.map do |exclusion|
          Measure.get(exclusion.measure_id, exclusion.sub_id).first
        end

        @outliers.delete_if do |outlier|
          @manual_exclusions.find { |exclusion| exclusion['measure_id']==outlier['measure_id'] && exclusion['sub_id']==outlier['sub_id'] }
        end

        render json: {exclusions: @manual_exclusions, outliers: @outliers}
      end
    end
  end
  
  def toggle_excluded
    ManualExclusion.toggle!(@patient, params[:measure_id], params[:sub_id], params[:rationale], current_user)
    redirect_to :controller => :measures, :action => :patients, :id => params[:measure_id], :sub_id => params[:sub_id]
  end
  
  def manage
    @unassigned = Record.page(params[:unassigned_page]).per(50).alphabetical.without_provider
    @provider = Provider.find(params[:provider_id])
    @records = Record.page(params[:provider_page]).per(25).alphabetical.by_provider(@provider, nil)
  end
  
  def update_all
    @provider = Provider.find(params[:provider_id])
    @assigned_records = Record.find(params[:records].keys)

    @assigned_records.each do |record|
      
      dates = params[:records][record.id.to_s]
      unless dates[:start_date].blank?
        start_date = Time.parse(dates[:start_date]).to_i
        end_date = end_date.blank? ? nil : Time.parse(dates[:end_date]).to_i
        attributes = {start_date: start_date, end_date: end_date}
        performance = record.provider_performances.detect { |perf| perf.provider_id == @provider.id }

        if performance
          performance.update_attributes(attributes)
        else
          record.provider_performances.create(attributes.merge(provider_id: @provider.id))
        end
      end
    end
    
    redirect_to manage_provider_patients_path(@provider)
  end
  
  def destroy
    @provider = Provider.find(params[:provider_id])
    @record = Record.find(params[:id])
    perf = @record.provider_performances.detect { |perf| perf.provider_id == @provider.id  }
    perf.destroy
    redirect_to manage_provider_patients_path(@provider)
  end
  
  private
  
  def load_patient
    @patient = Record.find(params[:id])
    authorize! :read, @patient
  end

  def validate_authorization!
    authorize! :read, Record
  end

end