class AccountController < ApplicationController
  include RailsWarden::Mixins::HelperMethods
  include RailsWarden::Mixins::ControllerOnlyMethods
  before_filter :set_up_executor
  before_filter :authenticate!  , :only=> [:update]
  
  
  def reset
    key = generate_reset_key
    @user = User.find_one({:username=>params[:username]})
    @user.reset_key = key
    @user.save
    #send email
    flash[:message]="Check email for reset link message here"
    render :template=>'acction/check_email'
  end
  
  
  def update
    get_user
    @user.update(params[:user])
    unless @user.save
      #do some I didn't save stuff here
    end
    
  end
  
  
  def create
   @user = User.new(params[:user])
   unless @user.save
      #do some I didn't save stuff here
   end
   
  end

  #just render the registration page
  def register
    
  end
  
  #check to see if the user name already exists
  def check_username
    if User.check_username(params[:user][:username])
   
    else
      
    end  
  end
  

private

  def generate_reset_key
    Time.new.to_i.to_s
  end
  
 def get_user
   @user = session[:user]
 end
end
