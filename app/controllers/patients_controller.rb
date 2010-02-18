require 'ui/grid'

class PatientsController < ApplicationController

  skip_before_filter :login_required
  layout  "site"
  
  def list
    @page_title = "list of patients"
    @list = UI::PaginatedResults.wrap(:patients, params) { |options|
        count = Patient.count
 
        if(count > 0 && options[:offset] > count)
          options[:offset] = count - options[:limit]
        end
        
        {:data => Patient.find(:all, options), :count => count}
    }
    return render 
  end
  
  def show
    redirect = false
    id = params[:id]
    
    @ret = params[:return] || "list"
    
    if id.nil? || id.to_i <= 0
      flash[:error] = "The patient id (#{id}) is invalid."
      return redirect_to @ret
    end 
      
    @patient = Patient.find_by_id(id.to_i)
      
    if @patient.nil?
      flash[:error] = "The patient id (#{id}) did not return any results"
      return redirect_to @ret
    end
    
    return render 
  end
  
end
