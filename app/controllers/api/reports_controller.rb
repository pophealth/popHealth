module Api

  class ReportsController < ApplicationController
    resource_description do
      short 'Reports'
      formats ['xml']
      description <<-RCDESC
        This resource is responsible for the generation of QRDA Category III reports from clincial
        quality measure calculations.
      RCDESC
    end
    before_filter :authenticate_user!
    skip_authorization_check

    api :GET, '/reports/qrda_cat3.xml', "Retrieve a QRDA Category III document"
    param :measure_ids, Array, :desc => 'The HQMF ID of the measures to include in the document', :required => false
    param :effective_date, String, :desc => 'Time in seconds since the epoch for the end date of the reporting period',
                                   :required => false
    param :provider_id, String, :desc => 'The Provider ID for CATIII generation'
    description <<-CDESC
      This action will generate a QRDA Category III document. If measure_ids and effective_date are not provided,
      the values from the user's dashboard will be used.
    CDESC
    def cat3
      measure_ids = params[:measure_ids] ||current_user.preferences["selected_measure_ids"]
      filter = measure_ids=="all" ? {}  : {:hqmf_id.in =>measure_ids}
      exporter =  HealthDataStandards::Export::Cat3.new
      effective_date = params["effective_date"] || current_user.effective_date || Time.gm(2012, 12, 31)
      end_date = Time.at(effective_date.to_i)
      provider = provider_filter = nil
      if params[:provider_id].present?
        provider = Provider.find(params[:provider_id])
        authorize! :read, provider 
        provider_filter = {}
        provider_filter['filters.providers'] = params[:provider_id] if params[:provider_id].present?
      end
      render xml: exporter.export(HealthDataStandards::CQM::Measure.top_level.where(filter),
                                   generate_header(provider),
                                   effective_date.to_i,
                                   end_date.years_ago(1),
                                   end_date, provider_filter), content_type: "attachment/xml"
    end

    api :GET, "/reports/patients" #/:id/:sub_id/:effective_date/:provider_id/:patient_type"
    param :id, String, :desc => "Measure ID", :required => true
    param :sub_id, String, :desc => "Measure sub ID", :required => false
    param :effective_date, String, :desc => 'Time in seconds since the epoch for the end date of the reporting period', :required => true
    param :provider_id, String, :desc => 'Provider ID for filtering quality report', :required => true
    param :patient_type, String, :desc => 'Outlier, Numerator, Denominator', :required => true
    description <<-CDESC
      This action will generate an Excel spreadsheet of relevant QRDA Category I Document based on the category of patients selected. 
    CDESC
    def patients
      type = params[:patient_type]        
      qr = QME::QualityReport.where(:effective_date => params[:effective_date].to_i, :measure_id => params[:id], :sub_id => params[:sub_id], "filters.providers" => params[:provider_id])
      
      authorize! :read, Provider.find(params[:provider_id])

      records = (qr.count > 0) ? qr.first.patient_results : []
   
      book = Spreadsheet::Workbook.new
      sheet = book.create_worksheet
      format = Spreadsheet::Format.new :weight => :bold		  
      
      measure = HealthDataStandards::CQM::Measure.where(id: params[:id]).first
      
      eff = Time.at(params[:effective_date].to_i)
      end_date = eff.strftime("%D")
      start_date = eff.month.to_s + "/" + eff.day.to_s + "/" + (eff.year-1).to_s
      # report header
      r=0
      sheet.row(r).push("Measure ID: ", '', measure.cms_id + ", " + "NQF" + measure.nqf_id)
      sheet.row(r+=1).push("Name: ", '', measure.name)
      sheet.row(r+=1).push("Description: ", '', measure.description)
      sheet.row(r+=1).push("Reporting Period: ", '', start_date + " - " + end_date)
      sheet.row(r+=1).push("Group: ", '', patient_type(type))
      (0..r).each do |i| 
        sheet.row(i).set_format(0, format) 
      end
      # table headers
      sheet.row(r+=2).push('MRN', 'First Name', 'Last Name', 'Gender', 'Birthdate')
      sheet.row(r).default_format = format
      # populate rows
      r+=1
      records.each do |record|
        value = record.value
        authorize! :read, Record.find_by(medical_record_number: value[:medical_record_id])
        if value["#{type}"] == 1
          sheet.row(r).push(value[:medical_record_id], value[:first], value[:last], value[:gender], Time.at(value[:birthdate]).strftime("%D"))
          r +=1
        end
      end

      today = Time.now.strftime("%D")  
      filename = "patients_" + measure.cms_id + "_" + patient_type(type) + "_" + "#{today}" + ".xls"
      data = StringIO.new '';
      book.write data;
      send_data(data.string, {
        :disposition => 'attachment',
        :encoding => 'utf8',
        :stream => false,
        :type => 'application/vnd.ms-excel',
        :filename => filename
      })
    end

    api :GET, '/reports/team_report', "Retrieve a QRDA Category III document"
    param :measure_id, String, :desc => 'The HQMF ID of the measure to include in the document', :required => true
    param :sub_id, String, :desc => 'The sub ID of the measure to include in the document', :required => false
    param :effective_date, String, :desc => 'Time in seconds since the epoch for the end date of the reporting period', :required => true
    param :team_id, String, :desc => 'The ID of the team for the measure report'
    description <<-CDESC
      This action will generate a Excel spreadsheet report for a team of providers for a given measure.
    CDESC
    def team_report
      measure_id = params[:measure_id]
      sub_id = params[:sub_id]
      team = Team.find(params[:team_id])
      
      book = Spreadsheet::Workbook.new
      sheet = book.create_worksheet
      format = Spreadsheet::Format.new :weight => :bold		  
      
      if sub_id
        measure = HealthDataStandards::CQM::Measure.where(:id => measure_id, :sub_id => sub_id).first
      else
        measure = HealthDataStandards::CQM::Measure.where(:id => measure_id).first
      end
      
      eff = Time.at(params[:effective_date].to_i)
      end_date = eff.strftime("%D")
      start_date = eff.month.to_s + "/" + eff.day.to_s + "/" + (eff.year-1).to_s
      # report header
      r=0
      sheet.row(r).push("Measure ID: ", measure.cms_id + ", " + "NQF" + measure.nqf_id)
      sheet.row(r+=1).push("Name: ", measure.name)
      sheet.row(r+=1).push("Reporting Period: ", start_date + " - " + end_date)
      sheet.row(r+=1).push("Team: ", team.name)
      (0..r).each do |i| 
        sheet.row(i).set_format(0, format) 
      end
      # table headers
      sheet.row(r+=2).push('Provider Name', 'NPI', 'Numerator', 'Denominator', 'Exclusions', 'Percentage')
      sheet.row(r).default_format = format
      # populate rows
      r+=1
      providers = team.providers.map {|id| Provider.find(id)}
      providers.each do |provider|
        authorize! :read, provider
        query = {:measure_id => measure_id, :sub_id => sub_id, :effective_date => params[:effective_date].to_i, 'filters.providers' => [provider.id.to_s]}
        cache = QME::QualityReport.where(query).first     
        if cache && cache.result
          performance_denominator = cache.result['DENOM'] - cache.result['DENEX']
          percent =  percentage(cache.result['NUMER'].to_f, performance_denominator.to_f)
          sheet.row(r).push(provider.full_name, provider.npi, cache.result['NUMER'], performance_denominator, cache.result['DENEX'], percent)
          r+=1
        end
      end

      today = Time.now.strftime("%D")
      filename = team.name + "_report_" + measure.cms_id + "_" + "#{today}" + ".xls"
      data = StringIO.new '';
      book.write data;
      send_data(data.string, {
        :disposition => 'attachment',
        :encoding => 'utf8',
        :stream => false,
        :type => 'application/vnd.ms-excel',
        :filename => filename
      })
    end

    api :GET, '/reports/measures_spreadsheet', "Retrieve a spreadsheet of measure calculations"
    param :username, String, :desc => 'Username of user to generate reports for'
    param :effective_date, String, :desc => 'Time in seconds since the epoch for the end date of the reporting period'
    param :provider_id, String, :desc => 'The Provider ID for spreadsheet generation', :required => true
    description <<-CDESC
      This action will generate an Excel spreadsheet document containing a list of measure calculations for the current user's selected measures.
    CDESC
    def measures_spreadsheet
      book = Spreadsheet::Workbook.new
      sheet = book.create_worksheet
      format = Spreadsheet::Format.new :weight => :bold

      user = User.where(:username => params[:username]).first || current_user
      effective_date = params[:effective_date] || current_user.effective_date      
      measure_ids = user.preferences['selected_measure_ids']
      
      unless measure_ids.empty?
        selected_measures = measure_ids.map{ |id| HealthDataStandards::CQM::Measure.where(:id => id)}
        # report header
        provider = Provider.find(params[:provider_id])
        authorize! :read, provider

        eff = Time.at(params[:effective_date].to_i)
        end_date = eff.strftime("%D")
        start_date = eff.month.to_s + "/" + eff.day.to_s + "/" + (eff.year-1).to_s
        
        r=0
        sheet.row(r).push("Reporting Period: ", '', start_date + " - " + end_date)
        sheet.row(r+=1).push("Provider: ", '', provider.full_name)
        sheet.row(r+=1).push("NPI: ", '', provider.npi)
        (0..r).each do |i|
          sheet.row(i).set_format(0, format)
        end
        # table headers
        sheet.row(r+=2).push('NQF ID', 'CMS ID', 'Sub ID', 'Title', 'Subtitle', 'Numerator', 'Denominator', 'Exclusions', 'Percentage')
        sheet.row(r).default_format = format
        
        # populate rows
        r+=1
        selected_measures.each do |measure|
          measure.sort_by!{|s| s.sub_id}.each do |sub|            
            query = {:measure_id => sub.measure_id, :sub_id => sub.sub_id, :effective_date => effective_date, 'filters.providers' => [provider.id.to_s]}
            cache = QME::QualityReport.where(query).first     
            performance_denominator = cache.result['DENOM'] - cache.result['DENEX']
            percent =  percentage(cache.result['NUMER'].to_f, performance_denominator.to_f)
            sheet.row(r).push(sub.nqf_id, sub.cms_id, sub.sub_id, sub.name, sub.subtitle, cache.result['NUMER'], performance_denominator, cache.result['DENEX'], percent)
            r+=1
          end
        end
      end
      today = Time.now.strftime("%D")
      filename = "measure-report_" + "#{today}" + ".xls"

      data = StringIO.new '';
      book.write data;
      send_data(data.string, {
        :disposition => 'attachment',
        :encoding => 'utf8',
        :stream => false,
        :type => 'application/vnd.ms-excel',
        :filename => filename
      })
    end


    api :GET, "/reports/cat1/:id/:measure_ids"
    formats ['xml']
    param :id, String, :desc => "Patient ID", :required => true
    param :measure_ids, String, :desc => "Measure IDs", :required => true
    param :effective_date, String, :desc => 'Time in seconds since the epoch for the end date of the reporting period',
                                   :required => false
    description <<-CDESC
      This action will generate a QRDA Category I Document. Patient ID and measure IDs (comma separated) must be provided. If effective_date is not provided,
      the value from the user's dashboard will be used.
    CDESC
    def cat1
      exporter = HealthDataStandards::Export::Cat1.new
      patient = Record.find(params[:id])
      authorize! :read, patient
      measure_ids = params["measure_ids"].split(',')
      measures = HealthDataStandards::CQM::Measure.where(:hqmf_id.in => measure_ids)
      end_date = params["effective_date"] || current_user.effective_date || Time.gm(2012, 12, 31)
      start_date = end_date.years_ago(1)
      render xml: exporter.export(patient, measures, start_date, end_date)
    end


    private
    
    def patient_type(type)
      # IPP, NUMER, DENOM, antinumerator, DENEX
      case type
      when "IPP"
        "Initial Patient Population"
      when "NUMER" 
        "Numerator"
      when "DENOM"
        "Denominator"
      when "antinumerator"
        "Outlier"
      when "DENEX"
        "Exclusion"
      else 
        "N/A"
      end
    end

    def percentage(numer, denom)	
      if denom == 0
        0
      else
        (numer/denom * 100).round(1)
      end
    end

    def generate_header(provider)
      header = Qrda::Header.new(APP_CONFIG["cda_header"])

      header.identifier.root = UUID.generate
      header.authors.each {|a| a.time = Time.now}
      header.legal_authenticator.time = Time.now
      header.performers << provider

      header
    end
  end
end
