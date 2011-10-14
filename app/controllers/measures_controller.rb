class MeasuresController < ApplicationController
  include MeasuresHelper

  before_filter :authenticate_user!
  before_filter :set_up_environment

  after_filter :hash_document, :only => [:measure_report, :patient_list]

  def index
    @selected_measures = current_user.selected_measures
    @grouped_selected_measures = @selected_measures.group_by {|measure| measure['category']}
    @categories = Measure.non_core_measures
    @core_measures = Measure.core_measures
    @core_alt_measures = Measure.core_alternate_measures
    render 'dashboard'
  end

  def result
    if @quality_report.calculated?
      @result = @quality_report.result
      render :json => @result
    else
      uuid = params[:uuid]
      unless params[:uuid]
        uuid = @quality_report.calculate
      end
      
      render :json => @quality_report.status(uuid)
    end
  end
  
  def period
    period_end = params[:effective_date]
    month, day, year = period_end.split('/')
    @effective_date = Time.local(year.to_i, month.to_i, day.to_i).to_i
    @period_start = MeasuresController.three_months_prior(@effective_date)
    if (params[:persist]=="true")
      current_user.effective_date = @effective_date
      current_user.save!
    end
    render :period, :status=>200
  end
  
  def definition
    @definition = @measure.definition
    render :json => @definition
  end

  def show
    @definition = @measure.definition
    @result = @quality_report.result
    render 'measure'
  end

  def patients
    @definition = @measure.definition
    @result = @quality_report.result
  end

  def measure_patients
    @result = @quality_report.result
    type = if params[:type]
      "value.#{params[:type]}"
    else
       "value.denominator"
     end
    @limit = (params[:limit] || 20).to_i
    @skip = ((params[:page] || 1).to_i - 1 ) * @limit
    sort = params[:sort] || "_id"
    sort_order = params[:sort_order] || :asc
    measure_id = params[:id] 
    sub_id = params[:sub_id]
    @records = mongo['patient_cache'].find({'value.measure_id' => measure_id, 'value.sub_id' => sub_id,
                                       'value.effective_date' => @effective_date, type => true},
                                      {:sort => [sort, sort_order], :skip => @skip, :limit => @limit}).to_a
    @total =  mongo['patient_cache'].find({'value.measure_id' => measure_id, 'value.sub_id' => sub_id,
                                      'value.effective_date' => @effective_date, type => true}).count
    @page_results = WillPaginate::Collection.create((params[:page] || 1), @limit, @total) do |pager|
       pager.replace(@records)
    end
    # log the patient_id of each of the patients that this user has viewed
    @page_results.each do |patient_container|
      Log.create(:username =>   current_user.username,
                 :event =>      'patient record viewed',
                 :patient_id => (patient_container['value'])['medical_record_id'])
    end
  end

  def patient_list
    measure_id = params[:id] 
    sub_id = params[:sub_id]
    @records = mongo['patient_cache'].find({'value.measure_id' => measure_id, 'value.sub_id' => sub_id,
                                            'value.effective_date' => @effective_date}).to_a
    # log the patient_id of each of the patients that this user has viewed
    @records.each do |patient_container|
      Log.create(:username =>   current_user.username,
                 :event =>      'patient record viewed',
                 :patient_id => (patient_container['value'])['medical_record_id'])
    end
    respond_to do |format|
      format.xml do
        headers['Content-Disposition'] = 'attachment; filename="excel-export.xls"'
        headers['Cache-Control'] = ''
        render :content_type => "application/vnd.ms-excel"
      end
    end
  end

  def measure_report
    Atna.log(current_user.username, :query)
    selected_measures = mongo['selected_measures'].find({:username => current_user.username}).to_a
    @report = {}
    @report[:start] = Time.at(@effective_date - 3 * 30 * 24 * 60 * 60) # roughly 3 months
    @report[:end] = Time.at(@effective_date)
    @report[:registry_name] = current_user.registry_name
    @report[:registry_id] = current_user.registry_id
    @report[:npi] = current_user.npi
    @report[:tin] = current_user.tin
    @report[:results] = []
    selected_measures.each do |measure|
      subs_iterator(measure['subs']) do |sub_id|
        @report[:results] << extract_result(measure['id'], sub_id, @effective_date)
      end
    end
    respond_to do |format|
      format.xml do
        response.headers['Content-Disposition']='attachment;filename=quality.xml';
        render :content_type=>'application/pqri+xml'
      end
    end
  end

  def select
    measure = Measure.add_measure(current_user.username, params[:id])
    render :partial => 'measure_stats', :locals => {:measure => measure}
  end

  def remove
    Measure.remove_measure(current_user.username, params[:id])
    render :text => 'Removed'
  end

  private

  def hash_document
    d = Digest::SHA1.new
    checksum = d.hexdigest(response.body)
    Log.create(:username => current_user.username, :event => 'document exported', :checksum => checksum)
  end

  def self.three_months_prior(date)
    Time.at(date - 3 * 30 * 24 * 60 * 60)
  end

  def set_up_environment
    @patient_count = mongo['records'].count
    if current_user && current_user.effective_date
      @effective_date = current_user.effective_date
    else
      @effective_date = Time.gm(2010, 12, 31).to_i
    end
    @period_start = MeasuresController.three_months_prior(@effective_date)
    if params[:id]
      @quality_report = QME::QualityReport.new(params[:id], params[:sub_id], 'effective_date' => @effective_date)
      @measure = QME::QualityMeasure.new(params[:id], params[:sub_id])
    end

  end

  def extract_result(id, sub_id, effective_date)
    qr = QME::QualityReport.new(id, sub_id, 'effective_date' => effective_date)
    result = qr.result
    {
      :id=>id,
      :sub_id=>sub_id,
      :population=>result['population'],
      :denominator=>result['denominator'],
      :numerator=>result['numerator'],
      :exclusions=>result['exclusions']
    }
  end

end