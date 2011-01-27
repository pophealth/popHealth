class LoginController < ApplicationController
  
  include RailsWarden::Mixins::HelperMethods
  include RailsWarden::Mixins::ControllerOnlyMethods
  
  
  def unauthenticated
     #just renders the login form
  end
  
  
  def logout
    warden.raw_session.inspect  # Without this inspect here.  The session does not clear :|
    warden.logout()
    redirect_to "/"
  end
  
  
  
end
