class MeasuresController < ApplicationController
  include MeasuresHelper

  before_filter :authenticate_user!
  before_filter :validate_authorization!
  before_filter :build_filters
  before_filter :set_up_environment
  before_filter :generate_report, :only => [:patients, :measure_patients]
  after_filter :hash_document, :only => :report
  
  def index
    @categories = Measure.non_core_measures
    @core_measures = Measure.core_measures
    @core_alt_measures = Measure.core_alternate_measures
    @all_measures = Measure.all_by_measure
  end
  
  def show
    respond_to do |wants|
      wants.html {}
      wants.json do
        SelectedMeasure.add_measure(current_user.username, params[:id])
        measures = params[:sub_id] ? Measure.get(params[:id], params[:sub_id]) : Measure.sub_measures(params[:id])
        render_measure_response(measures, params[:jobs]) do |sub|
          QME::QualityReport.new(sub['id'], sub['sub_id'], 'effective_date' => @effective_date, 'filters' => @filters)
        end
      end
    end
  end
  
  def providers    
    respond_to do |wants|
      wants.html do
        @providers = Provider.alphabetical
        @races = Race.ordered
        @providers_by_team = @providers.group_by { |pv| pv.team.try(:name) || "Other" }
      end
      
      wants.json do
        
        providerIds = params[:provider].empty? ?  Provider.all.map { |pv| pv.id.to_s } : @filters.delete('providers')

        render_measure_response(providerIds, params[:jobs]) do |pvId|
          QME::QualityReport.new(params[:id], params[:sub_id], 'effective_date' => @effective_date, 'filters' => @filters.merge('providers' => [pvId]))
        end
      end
    end
  end
  
  def remove
    SelectedMeasure.remove_measure(current_user.username, params[:id])
    render :text => 'Removed'
  end
  
  def patients
  end

  def measure_patients
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
    @report[:registry_name] = current_user.registry_name
    @report[:registry_id] = current_user.registry_id
    @report[:provider_reports] = []
    
    case params[:type]
    when 'practice'
      @report[:provider_reports] << generate_xml_report(nil, selected_measures, false)
    when 'provider'
      Provider.all.each do |provider|
        @report[:provider_reports] << generate_xml_report(provider, selected_measures)
      end
      @report[:provider_reports] << generate_xml_report(nil, selected_measures)
    end

    respond_to do |format|
      format.xml do
        response.headers['Content-Disposition']='attachment;filename=quality.xml';
        render :content_type=>'application/pqri+xml'
      end
    end
  end
  
  def period
    month, day, year = params[:effective_date].split('/')
    set_effective_date(Time.local(year.to_i, month.to_i, day.to_i).to_i, params[:persist]=="true")
    render :period, :status=>200
  end

  private

  def generate_xml_report(provider, selected_measures, provider_report=true)
    report = {}
    report[:start] = Time.at(@period_start)
    report[:end] = Time.at(@effective_date)
    report[:npi] = provider ? provider.npi : '' 
    report[:tin] = provider ? provider.tin : ''
    report[:results] = []
    
    selected_measures.each do |measure|
      subs_iterator(measure['subs']) do |sub_id|
        report[:results] << extract_result(measure['id'], sub_id, @effective_date, (provider_report) ? [provider ? provider.id.to_s : nil] : nil)
      end
    end
    report
  end
  
  def extract_result(id, sub_id, effective_date, providers=nil)
    if (providers)
      qr = QME::QualityReport.new(id, sub_id, 'effective_date' => effective_date, 'filters' => {'providers' => providers})
    else
      qr = QME::QualityReport.new(id, sub_id, 'effective_date' => effective_date)
    end
    qr.calculate(false) unless qr.calculated?
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
  
  
  def set_up_environment
    @patient_count = mongo['records'].count
    if params[:id]
      measure = QME::QualityMeasure.new(params[:id], params[:sub_id])
      render(:file => "#{RAILS_ROOT}/public/404.html", :layout => false, :status => 404) unless measure
      @definition = measure.definition
    end
  end
  
  def generate_report
    @quality_report = QME::QualityReport.new(@definition['id'], @definition['sub_id'], 'effective_date' => @effective_date, 'filters' => @filters)
    if @quality_report.calculated?
      @result = @quality_report.result
    else
      @quality_report.calculate
    end
  end
  
  def render_measure_response(collection, uuids)
    result = collection.inject({jobs: {}, result: [], job_statuses: {}}) do |memo, var|
      report = yield(var)
      if report.calculated?
        memo[:result] << report.result
      else
        key = "#{report.instance_variable_get(:@measure_id)}#{report.instance_variable_get(:@sub_id)}"
        memo[:jobs][key] = (uuids.nil? || uuids[key].nil?) ? report.calculate : uuids[key]
        memo[:job_statuses][key] = report.status(memo[:jobs][key])['status']
      end
      
      memo
    end

    render :json => result.merge(:complete => result[:jobs].empty?)
  end
  
  def build_filters
    if request.xhr?
      providers = params[:provider] || []
      races = params[:race] ? Race.selected(params[:race]).all : []
      races_ethnicities = []
      races.each {|race| races_ethnicities << {race: race.flatten(:race), ethnicity: race.flatten(:ethnicity)}}
      genders = params[:gender] ? params[:gender] : []

      @filters = {'providers' => providers, 'races_ethnicities' => races_ethnicities, genders: genders}
    else
      @providers = Provider.alphabetical
      @races = Race.ordered
      @genders = [{name: 'Male', id: 'M'}, {name: 'Female', id: 'F'}]
      @providers_by_team = @providers.group_by { |pv| pv.team.try(:name) || "Other" }
    end

  end

  def validate_authorization!
    authorize! :read, Measure
  end
  
  # def authorize_instance_variables
  #   instance_variable_names.each do |variable|
  #     values = instance_variable_get(variable)
  #     if (values.is_a? Mongoid::Criteria or values.is_a? Array)
  #       values.each do |value|
  #         if (value.is_a? Provider)
  #           authorize! :read, value
  #         end
  #       end
  #     end
  #     if (values.is_a? Provider)
  #       authorize! :read, values
  #     end
  #   end
  # end
  
end