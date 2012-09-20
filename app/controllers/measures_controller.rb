require 'ostruct'
class MeasuresController < ApplicationController
  include MeasuresHelper

  before_filter :authenticate_user!
  before_filter :validate_authorization!
  before_filter :setup_filters
  before_filter :set_up_environment
  after_filter :hash_document, :only => :measure_report
  
  add_breadcrumb_dynamic([:selected_provider], only: %w{index show patients}) {|data| provider = data[:selected_provider]; {title: (provider ? provider.full_name : nil), url: "#{Rails.configuration.relative_url_root}/?npi=#{(provider) ? provider.npi : nil}"}}
  add_breadcrumb_dynamic([:definition], only: %w{providers}) do|data| 
    measure = data[:definition];
    if measure
      {title: "#{measure['endorser']}#{measure['id']}" + (measure['sub_id'] ? "#{measure['sub_id']}" : ''), url: "#{Rails.configuration.relative_url_root}/measure/#{measure['id']}"+(measure['subid'] ? "/#{measure['sub_id']}" : '')+"/providers"}
    else
      {}
    end
  end
  add_breadcrumb_dynamic([:definition, :selected_provider], only: %w{show patients}) {|data| measure = data[:definition]; provider = data[:selected_provider]; {title: "#{measure['endorser']}#{measure['id']}" + (measure['sub_id'] ? "#{measure['sub_id']}" : ''), url: "#{Rails.configuration.relative_url_root}/measure/#{measure['id']}"+(measure['subid'] ? "/#{measure['sub_id']}" : '')+(provider ? "?npi=#{provider.npi}" : "/providers")}}
  add_breadcrumb 'parameters', '', only: %w{show}
  add_breadcrumb 'patients', '', only: %w{patients}
  
  def index
    @categories = Measure.non_core_measures
    @core_measures = Measure.core_measures
    @core_alt_measures = Measure.core_alternate_measures
    @alt_measures = Measure.alternate_measures.group_by { |m| m['category'] }
  end
  
  def show
    respond_to do |wants|
      wants.html do
        build_filters if (@selected_provider)
        generate_report
        @result = @quality_report.result
      end
      wants.json do # this is what is called when displaying a measure on the index page

#        SelectedMeasure.add_measure(current_user.username, params[:id])
        # Current user/filter measures
        measures = params[:sub_id] ? Measure.get(params[:id], params[:sub_id]) : Measure.sub_measures(params[:id])
        
        render_measure_response(measures, params[:jobs]) do |sub|
          {
            report: QME::QualityReport.new(sub['id'], sub['sub_id'], 'effective_date' => @effective_date, 'filters' => @filters),
            #fullReport: QME::QualityReport.new(sub['id'], sub['sub_id'], 'effective_date' => @effective_date, 'filters' => nil),
            patient_count: @patient_count
          }
        end

        # Full database measures
        # fullMeasures = params[:sub_id] ? Measure.get(params[:id], params[:sub_id]) : Measure.sub_measures(params[:id])
        
        # render_measure_response(fullMeasures, params[:jobs]) do |sub|
        #  {
        #    report: QME::QualityReport.new(sub['id'], sub['sub_id'], 'effective_date' => @effective_date, 'filters' => nil),
        #    patient_count: @patient_count
        #  }
        #end
      end
    end
  end
  
  def definition
    render :json => @definition
  end
  def result

    uuid = generate_report(params[:uuid])
    
    if (@result)
      render :json => @result
    else
      render :json => @quality_report.status(uuid)
    end
    
  end
  
  
  def providers    
    authorize! :manage, :providers

    
    
    respond_to do |wants|
      wants.html {}
      
      wants.js do
        
        @providers = Provider.page(params[:page]).per(20).userfilter(current_user).alphabetical
        @providers = @providers.any_in(team_id: params[:team]) if params[:team]
        
      end
      
      wants.json do

            
        providerIds = params[:provider].blank? ?  Provider.all.map { |pv| pv.id.to_s } : @filters.delete('providers')
        
        render_measure_response(providerIds, params[:jobs]) do |pvId|
          filters = @filters ? @filters.merge('providers' => [pvId]) : {'providers' => [pvId]}
          { 
            report: QME::QualityReport.new(params[:id], params[:sub_id], 'effective_date' => @effective_date, 'filters' => filters),
            patient_count: @patient_count
          }
        end
      end
    end
    
    # @time_here2 = Time.now
    # 
  end
  
  def remove
    SelectedMeasure.remove_measure(current_user.username, params[:id])
    render :text => 'Removed'
  end
  
  def select
    SelectedMeasure.add_measure(current_user.username, params[:id])
    render :text => 'Select'
  end
  
  def patients
    build_filters # if (@selected_provider)
    generate_report
  end

  # This is used to populate the patient list for a selected measure
  def measure_patients

    @type = params[:type] || 'denominator'
    @limit = (params[:limit] || 20).to_i
    @skip = ((params[:page] || 1).to_i - 1 ) * @limit
    sort = params[:sort] || "_id"
    sort_order = params[:sort_order] || :asc
    measure_id = params[:id] 
    sub_id = params[:sub_id]
    
    query = {'value.measure_id' => measure_id, 'value.sub_id' => sub_id, 'value.effective_date' => @effective_date}
    
    if (@type == 'exclusions')
      query.merge!({'$or'=>[{"value.#{@type}" => true}, {'value.manual_exclusion'=>true}]})
    else
      query.merge!({"value.#{@type}" => true, 'value.manual_exclusion'=>{'$ne'=>true}})
    end
    
    if (@selected_provider)
      result = PatientCache.by_provider(@selected_provider, @effective_date).where(query);
    else
      authorize! :manage, :providers
      # result = PatientCache.all.where(query)
      result = PatientCache.provider_in(Provider.generateUserProviderIDList(current_user)).where(query)
    end
    @total = result.count
    @records = result.order_by(["value.#{sort}", sort_order]).skip(@skip).limit(@limit);
    
    @manual_exclusions = {}
    ManualExclusion.selected(@records.map {|record| record['value']['medical_record_id']}).map {|exclusion| @manual_exclusions[exclusion.medical_record_id] = exclusion} if (@type == 'exclusions')
    
    @page_results = WillPaginate::Collection.create((params[:page] || 1), @limit, @total) do |pager|
       pager.replace(@records)
    end
    # log the medical_record_number of each of the patients that this user has viewed
    @page_results.each do |patient_container|
      Log.create(:username =>   current_user.username,
                 :event =>      'patient record viewed',
                 :medical_record_number => (patient_container['value'])['medical_record_id'])
    end
  end

  # excel patient list
  def patient_list
    measure_id = params[:id] 
    sub_id = params[:sub_id]
    
    query = {'value.measure_id' => measure_id, 'value.sub_id' => sub_id, 'value.effective_date' => @effective_date, 'value.population'=>true}

    if (@selected_provider)
      result = PatientCache.by_provider(@selected_provider, @effective_date).where(query);
    else
      authorize! :manage, :providers
      # result = PatientCache.all.where(query)
      result = PatientCache.provider_in(Provider.generateUserProviderIDList(current_user)).where(query)
    end
    @records = result.order_by(["value.medical_record_id", 'desc']);
    
    @manual_exclusions = {}
    ManualExclusion.selected(@records.map {|record| record['value']['medical_record_id']}).map {|exclusion| @manual_exclusions[exclusion.medical_record_id] = exclusion}
    
    # log the medical_record_number of each of the patients that this user has viewed
    @records.each do |patient_container|
      Log.create(:username =>   current_user.username,
                 :event =>      'patient record viewed',
                 :medical_record_number => (patient_container['value'])['medical_record_id'])
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
      authorize! :manage, :providers
      @report[:provider_reports] << generate_xml_report(nil, selected_measures, false)
    when 'provider'
      providers = Provider.selected_or_all(params[:provider])
      providers.each do |provider|
        authorize! :read, provider
        @report[:provider_reports] << generate_xml_report(provider, selected_measures)
      end
      # add patients without a provider
      if ((can? :manage, :providers) && (providers.size > 1))
        @report[:provider_reports] << generate_xml_report(nil, selected_measures) 
      end
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
        report[:results] << extract_result(measure['id'], sub_id, @effective_date, ((provider_report) ? [provider ? provider.id.to_s : nil] : nil))
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
    # @patient_count = (@selected_provider) ? @selected_provider.records(@effective_date).count : mongo['records'].count
    @patient_count ||= (@selected_provider) ? @selected_provider.records(@effective_date).count : Record.provider_in(Provider.generateUserProviderIDList(current_user)).count
    if params[:id]
      measure = QME::QualityMeasure.new(params[:id], params[:sub_id])
      render(:file => "#{RAILS_ROOT}/public/404.html", :layout => false, :status => 404) unless measure
      @definition = measure.definition
    end
  end
  
  def generate_report(uuid = nil)
    @quality_report = QME::QualityReport.new(@definition['id'], @definition['sub_id'], 'effective_date' => @effective_date, 'filters' => @filters)
    if @quality_report.calculated?
      @result = @quality_report.result
    else
      unless uuid
        uuid = @quality_report.calculate
      end
    end
    return uuid
  end
  
  #*********************************************************************************************************
  def render_measure_response(collection, uuids)
    result = collection.inject({jobs: {}, result: [], job_statuses: {}}) do |memo, var|
      data = yield(var)
      report = data[:report]
      patient_count = data[:patient_count]

      if report.calculated?
        memo[:result] << report.result.merge({'patient_count'=>patient_count})
      else
        measure_id = report.instance_variable_get(:@measure_id)
        sub_id = report.instance_variable_get(:@sub_id)
        filters = report.instance_variable_get(:@parameter_values)['filters']
        key = "#{measure_id}#{sub_id}"
        uuid = (uuids.nil? || uuids[key].nil?) ? report.calculate : uuids[key]
        job = {uuid: uuid, status: report.status(uuid)['status'], measure_id: measure_id, sub_id: sub_id, filters: filters}
        memo[:jobs][key] = job
        memo[:result] << {job: job}
      end
      
      memo
    end

    render :json => result.merge(:complete => result[:jobs].empty?, :failed => !(result[:jobs].values.keep_if {|job| job[:status] == 'failed'}).empty?)
  end
  #*********************************************************************************************************
  
  def setup_filters
    
    if !can?(:read, :providers) || params[:npi]
      npi = params[:npi] ? params[:npi] : current_user.npi
      @selected_provider = Provider.first(conditions: {npi: npi})
      authorize! :read, @selected_provider
    end
    
    if request.xhr?
      build_filters
      
    else
      
      if can?(:read, :providers)
        @providers = Provider.page(@page).per(20).userfilter(current_user).alphabetical
        @providers_for_filter = Provider.userfilter(current_user).alphabetical
        if APP_CONFIG['disable_provider_filters']
          @teams = Team.alphabetical
          @page = params[:page]
        else
          @providers_by_team = @providers.group_by { |pv| pv.team.try(:name) || "Other" }
          # Removed to enforce team display
          # @providers_by_team['Other'] ||= []
          # @providers_by_team['Other'] << OpenStruct.new(full_name: 'No Providers', id: 'null')
          @providers_for_filter_by_team = @providers_for_filter.group_by { |pv| pv.team.try(:name) || "Other" }
          # Removed to enforce team display
          # @providers_for_filter_by_team['Other'] ||= []
          # @providers_for_filter_by_team['Other'] << OpenStruct.new(full_name: 'No Providers', id: 'null')
        end
      end

      @races = Race.ordered
      @ethnicities = Ethnicity.ordered
      @genders = [{name: 'Male', id: 'M'}, {name: 'Female', id: 'F'}]
      @languages = Language.ordered
      
    end

  end
  
  def build_filters
    providers = nil
    
    if params[:provider]
      providers = params[:provider]
    elsif params[:team] && params[:team].size != Team.count
      providers = Provider.any_in(team_id: params[:team]).map { |pv| pv.id.to_s }
      
    else
      # Changed to, with setting the filters, to filter based on the user
      # providers = nil
      providers = Provider.userfilter(current_user).map { |pv| pv.id.to_s }
    end

    races = params[:race] ? Race.selected(params[:race]).all : nil
    ethnicities = params[:ethnicity] ? Ethnicity.selected(params[:ethnicity]).all : nil
    languages = params[:language] ? Language.selected(params[:language]).all : nil
    genders = params[:gender] ? params[:gender] : nil
    
    @filters = {}
    @filters.merge!({'providers' => providers}) if providers
    @filters.merge!({'races'=>(races.map {|race| race.codes}).flatten}) if races
    @filters.merge!({'ethnicities'=>(ethnicities.map {|ethnicity| ethnicity.codes}).flatten}) if ethnicities
    @filters.merge!({'languages'=>(languages.map {|language| language.codes}).flatten}) if languages
    @filters.merge!({'genders' => genders}) if genders
    
    if @selected_provider
      @filters['providers'] = [@selected_provider.id.to_s]
    else
      authorize!(:read, :providers)
    end
    
    @filters = nil if @filters.empty?
    
  end

  def validate_authorization!
    authorize! :read, Measure
  end
  
end
