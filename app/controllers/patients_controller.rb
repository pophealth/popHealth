require 'ui/grid'

class PatientsController < ApplicationController

  skip_before_filter :login_required
  layout  "site"
  
  #GET
  def list
    @page_title = "list of patients"
    @query = ""
    
    #TODO: abstract this out into a module for active record. 
    if params[:query].nil? && params[:query] != ""
      @list = UI::PaginatedResults.wrap(:patients, params) { |options|
          count = Patient.count
 
          if(count > 0 && options[:offset] > count)
            options[:offset] = count - options[:limit]
          end
        
          {:data => Patient.find(:all, options), :count => count}
      }
    else 
      @list = UI::PaginatedResults.wrap(:patients, params) { |options|
        count = Patient.count_by_sql("SELECT COUNT( DISTINCT patients.id) from patients #{params[:query]} ")
        
          if(count > 0 && options[:offset] > count)
            options[:offset] = count - options[:limit]
          end
        
        {:data => Patient.find_by_sql("SELECT patients.* FROM patients #{params[:query]} LIMIT #{options[:limit]} OFFSET #{options[:offset]}"), :count => count}
      }
      @query = params[:query]
    end
    
    return render 
  end
  
  # GET
  def show
    redirect = false
    id = params[:id]
    
    @query = params[:query] || ""
    
    @ret = params[:return]  || "/patients/list/"
    @ret = @ret + (params[:return].nil? ? ("?query=" + CGI.escape(@query)) : ("&query=" + CGI.escape(@query)))
    
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
