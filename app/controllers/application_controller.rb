# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
 
  # AuthenticationSystem supports the acts_as_authenticated
  include AuthenticatedSystem

  filter_parameter_logging :password
  
  attr_accessor :inline_javascript
  attr_accessor :keywords
  attr_accessor :description
  
  def initialize
    inline_javascript = ""
    #todo: put this information in an about page.
    # keywords and descriptions should always be relevant to actual content on the page.
    # search engines usually decrease your validity for having keywords that do not occur in the content. 
    @keywords = "popHealth population, health, MITRE, MITRE corporation, FHA, Federal Health Architecture, "
    @keywords << "HHS, Health and Human Services, C32, HITSP, HITSP C32, XML, quality, report, "
    @keywords << " health case reporting, emergency preparedness, laika, region, regional, national, states, pay for performance, PFP"
    @description = "popHealth is a popuation reporting web application, developed by the MITRE Corporation."
  end

  # "remember me" functionality
  before_filter :login_from_cookie

  before_filter :login_required

  # See ActionController::RequestForgeryProtection for details
  protect_from_forgery :secret => 'dece9bb4d13101130349c3bef2c45b37'
  
  protected

  # Set the last selected vendor by id. The value is saved in the session.
  #
  # This method is used by TestPlan#create to retain previous selections as a convenience
  # in the UI.
  def last_selected_vendor_id=(vendor_id)
    session[:previous_vendor_id] = vendor_id
  end

  # Get the last selected vendor from the session.
  def last_selected_vendor
    begin
      Vendor.find_by_id(session[:previous_vendor_id]) if session[:previous_vendor_id]
    rescue ActiveRecord::StatementInvalid
    end
  end

  # Set the page title for the controller, can be overridden by calling page_title in any controller action.
  def self.page_title(title)
    class_eval %{
      before_filter :set_page_title
      def set_page_title
        @page_title = %{#{title}}
      end
    }
  end

  # Set the page title for the current action.
  def page_title(title)
    @page_title = title
  end

  def require_administrator
    if current_user.try(:administrator?)
      true
    else
      redirect_to test_plans_url
      false
    end
  end

  def rescue_action_in_public(exception)
    if request.xhr?
      render :update do |page|
        page.alert("An internal error occurred, please report this to #{FEEDBACK_EMAIL}.")
      end
    else
      render :template => "rescues/error"
    end
  end

  #def log_error(exception) 
  #  super(exception)
  #  begin
  #    logger.error("Attempting to send error email")
  #    ErrorMailer.deliver_errormail(exception, 
  #     clean_backtrace(exception), 
  #      session.instance_variable_get("@data"), 
  #      params,
  #      request.env)
  #  rescue => e
  #    logger.error("Failed to send error email")
  #    logger.error(e)
  #  end
  #end
  
end
