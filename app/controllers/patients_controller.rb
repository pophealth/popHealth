require 'ui/grid'

class PatientsController < ApplicationController


  before_filter :initialize_reports
  layout  "site"
  
  def initialize_reports
     @reports = Report.all_and_populate(:order => 'title asc')
     @population_count = Patient.count_by_sql("select count(*) from patients").to_s
     @population_name = "Sagacious Healthcare Services"
  end
  
  #GET
  def list
    @page_title = "list of patients"
    @report_id = params[:report_id] || params[:id]
    @ret = "/pophealth"
    
    #TODO: abstract this out into a module for active record. 
    if @report_id.nil? || @report_id == ""
    
      query = Report.find_and_generate_patients_query(params[:report_id], "")
      if !query.nil?
        @report_id = params[:report_id]
        @list = UI::PaginatedResults.wrap(:patients, params) { |options|
          count = Patient.count_by_sql("SELECT COUNT( DISTINCT patients.id) FROM patients #{query} ")
        
            if(count > 0 && options[:offset] > count)
              options[:offset] = count - options[:limit]
            end
        
          {:data => Patient.find_by_sql("SELECT patients.* FROM patients #{query} LIMIT #{options[:limit]} OFFSET #{options[:offset]}"), :count => count}
        }
        @ret = @ret + "/report/" + @report_id.to_s
        render 
      end
    end
    
     @list = UI::PaginatedResults.wrap(:patients, params) { |options|
          count = Patient.count
 
          if(count > 0 && options[:offset] > count)
            options[:offset] = count - options[:limit]
          end
        
          {:data => Patient.find(:all, options), :count => count}
      }
      first = Report.first
      if !first.nil?
          @report_id = first.id.to_s
          @ret = @ret + "/report/" + first.id.to_s
      end
    
    return render 
  end
  
  # GET
  def show
    redirect = false
    id =  params[:id]
        
    @report_id = params[:report_id]|| ""
   
     if @report_id == ""
        first = Report.first;
        if !first.nil?
          @report_id = first.id.to_s
        end
      end
    
    @return = CGI.unescape(params[:return])
    @ret =  (params[:return].nil? ? "/patients/list/?" : "#{@return}&amp;")
    @ret = @ret + "report_id=" + @report_id
    
   
    
    
    if id.nil? || id.to_i <= 0
      flash[:error] = "The patient id (#{id}) is invalid."
      return redirect_to @ret 
    end 
      
    @patient = Patient.find_by_id(id.to_i)
      
    if @patient.nil?
      flash[:error] = "The patient id (#{id}) did not return any results"
      return redirect_to @ret 
    end
    
    @page_title = "#{@patient.name}'s HRecord "
    
    return render 
  end
  alias :hrecord :show
  
end
