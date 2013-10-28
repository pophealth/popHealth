require 'ostruct'
class MeasuresController < ApplicationController
  include MeasuresHelper

  before_filter :authenticate_user!
  before_filter :validate_authorization!
  before_filter :filter_order
  after_filter :hash_document, :only => :measure_report
  
  def filter_order
    setup_filters
    set_up_environment
  end

  add_breadcrumb_dynamic([:selected_provider], only: %w{index show patients}) {|data| provider = data[:selected_provider]; {title: (provider ? provider.full_name : nil), url: "#{Rails.configuration.relative_url_root}/?npi=#{(provider) ? provider.npi : nil}"}}
  add_breadcrumb_dynamic([:definition], only: %w{providers}) do|data| 
    measure = data[:definition];
    if measure
      {title: "#{measure['endorser']}#{measure['id']}" + (measure['sub_id'] ? "#{measure['sub_id']}" : ''), url: "#{Rails.configuration.relative_url_root}/measure/#{measure['id']}"+(measure['subid'] ? "/#{measure['sub_id']}" : '')+"/providers"}
    else
      {}
    end
  end

  add_breadcrumb_dynamic([:definition, :selected_provider], only: %w{show patients})  do |data| 
    measure = data[:definition]; provider = data[:selected_provider]
    {title: "#{measure['endorser']}#{measure['id']}" + (measure['sub_id'] ? "#{measure['sub_id']}" : ''), 
     url: "#{Rails.configuration.relative_url_root}/measure/#{measure['id']}"+(measure['sub_id'] ? "/#{measure['sub_id']}" : '')+(provider ? "?npi=#{provider.npi}" : "/providers")}
  end

  add_breadcrumb 'parameters', '', only: %w{show}
  add_breadcrumb 'patients', '', only: %w{patients}
  
  def index
    @categories = HealthDataStandards::CQM::Measure.categories
  end
  
  def show
    respond_to do |wants|
      wants.html do
        build_filters if (@selected_provider)
        generate_report
        @result = @quality_report.result
      end
      wants.json do
        measures = params[:sub_id] ? QME::QualityMeasure.get(params[:id], params[:sub_id]) : QME::QualityMeasure.sub_measures(params[:id])
        
        render_measure_response(measures, params[:jobs]) do |sub|
          {
            report: QME::QualityReport.new(sub['id'], sub['sub_id'], 'effective_date' => @effective_date, 'filters' => @filters, 'oid_dictionary' => @oid_dictionary),
            patient_count: @patient_count
          }
        end
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
        @providers = Provider.page(params[:page]).per(20).alphabetical
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
    build_filters if (@selected_provider)
    generate_report
  end

  def measure_patients

    @type = params[:type] || 'DENOM'
    @limit = (params[:limit] || 20).to_i
    @skip = ((params[:page] || 1).to_i - 1 ) * @limit
    sort = params[:sort] || "_id"
    sort_order = params[:sort_order] || :asc
    measure_id = params[:id] 
    sub_id = params[:sub_id]
    
    query = {'value.measure_id' => measure_id, 'value.sub_id' => sub_id, 'value.effective_date' => @effective_date}
    
    if (@type == 'exclusions')
      query.merge!({'$or'=>[{"value.#{@type}" => 1}, {'value.manual_exclusion'=>true}]})
    else
      query.merge!({"value.#{@type}" => 1, 'value.manual_exclusion'=>{'$ne'=>true}})
    end
    
    if (@selected_provider)
      result = PatientCache.by_provider(@selected_provider, @effective_date).where(query);
    else
      authorize! :manage, :providers
      result = PatientCache.all.where(query)
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
      result = PatientCache.all.where(query)
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

  def qrda_cat3
    Atna.log(current_user.username, :query)
    selected_measures = current_user.selected_measures

    measure_ids = selected_measures.map{|measure| measure['id']}
    expected_results = QueryCache.in(:measure_id => measure_ids).where(:effective_date => current_user.effective_date)

    results = {}
    expected_results.each do |value|
      result = results[value["measure_id"]] ||= {"hqmf_id"=>value["measure_id"], "population_ids" => {}}
      population_ids = value["population_ids"]
      strat_id = population_ids["stratification"]
      population_ids.each_pair do |pop_key,pop_id|
        if pop_key != "stratification" 
          pop_result  = result["population_ids"][pop_id] ||= {"type"=> pop_key}
          pop_val = value[pop_key]
          if strat_id
            pop_result["stratifications"] ||= {}
            pop_result["stratifications"][strat_id] = pop_val
          else
            pop_result["value"] = pop_val
          end
        end
      end
    end
    @results = results
    @measures = MONGO_DB['measures'].find({:hqmf_id => {"$in" => measure_ids}, :sub_id => {"$in" =>[nil,'a']}})

    respond_to do |format|
      format.xml do
        response.headers['Content-Disposition']='attachment;filename=qrda_cat3.xml';
        render :content_type=>'application/xml'
      end
    end
  end

  def measure_report
    Atna.log(current_user.username, :query)
    selected_measures = current_user.selected_measures
    
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
    set_effective_date(Time.gm(year.to_i, month.to_i, day.to_i).to_i, params[:persist]=="true")
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
    qr.calculate unless qr.calculated?
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
    provider_npi = params[:npi]
    if @current_user.admin? && provider_npi
      @patient_count = Provider.where(:npi => "#{provider_npi}").first.records(@effective_date).count
    elsif @current_user.admin?
      @patient_count = Record.count
    elsif @selected_provider
      @patient_count = @selected_provider.records(@effective_date).count
    end
    
    @patient_count = (@selected_provider) ? @selected_provider.records(@effective_date).count : Record.count
    if params[:id]
      measure = QME::QualityMeasure.new(params[:id], params[:sub_id])
      render(:file => "#{RAILS_ROOT}/public/404.html", :layout => false, :status => 404) unless measure
      @definition = measure.definition
      @oid_dictionary = OidHelper.generate_oid_dictionary(@definition)
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
  
  def render_measure_response(collection, uuids)
    result = collection.inject({jobs: {}, result: []}) do |memo, var|
      data = yield(var)
      report = data[:report]
      patient_count = data[:patient_count]

      if report.calculated?
        memo[:result] << report.result.merge({'patient_count'=>patient_count})
      else
        measure_id = report.instance_variable_get(:@measure_id)
        sub_id = report.instance_variable_get(:@sub_id)
        
        key = "#{measure_id}#{sub_id}"
        uuid = (uuids.nil? || uuids[key].nil?) ? report.calculate : uuids[key]
        filters = report.instance_variable_get(:@parameter_values)['filters']
        job = {uuid: uuid, status: report.status(uuid)['status'], measure_id: measure_id, sub_id: sub_id, filters: filters}

        memo[:jobs][key] = job
        memo[:result] << {job: job}
      end

      memo
    end

    render :json => result.merge(:complete => result[:jobs].empty?, :failed => !(result[:jobs].values.keep_if {|job| job[:status] == 'failed'}).empty?)
  end
  
  def setup_filters
    
#    if !can?(:read, :providers) || params[:npi]
#      npi = params[:npi] ? params[:npi] : current_user.npi
#      @selected_provider = Provider.where(conditions: {npi: npi}).first
#      authorize! :read, @selected_provider
#    end
    
    user_npi = current_user.npi
    measures_npi = params[:npi]

    if (measures_npi) 
      @selected_provider = Provider.where(:npi => "#{measures_npi}").first
      authorize! :read, @selected_provider
    elsif (user_npi)
      @selected_provider = Provider.where(:npi => "#{user_npi}").first
      authorize! :read, @selected_provider
    end

    if request.xhr?
      build_filters
    else
      if can?(:read, :providers)
        @providers = Provider.page(@page).per(20).alphabetical
        if APP_CONFIG['disable_provider_filters']
          @teams = Team.alphabetical
          @page = params[:page]
        else
          other = Team.new(name: "Other")
          @providers_by_team = @providers.group_by { |pv| pv.team || other }
          @providers_by_team[other] ||= []
          # @providers_by_team['Other'] << OpenStruct.new(full_name: 'No Providers', id: 'null')
        end
      end

      @races = Race.ordered
      @ethnicities = Ethnicity.ordered
      @genders = [{name: 'Male', id: 'M'}, {name: 'Female', id: 'F'}].map { |g| OpenStruct.new(g)}
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
      providers = nil
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
    authorize! :read, HealthDataStandards::CQM::Measure
  end
  
end
