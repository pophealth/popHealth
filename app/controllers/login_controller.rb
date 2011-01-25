class LoginController < ApplicationController
  
  
  def unauthenticated
     #just renders the login form
  end
  
  
  def logout
    session.clear
  end
  
  
  
end
