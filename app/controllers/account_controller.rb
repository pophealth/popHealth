class AccountController < ApplicationController
  include RailsWarden::Mixins::HelperMethods
  include RailsWarden::Mixins::ControllerOnlyMethods
  before_filter :authenticate!  , :only=> [:update,:index]
  
  def index
    
  end
  
  
  def reset_password
    key = generate_reset_key
    @user = User.find_one({:email=>params[:email]})
    @user.reset_key = key
    @user.save
    Notifier.reset_password(@user).deliver
    #send email
    flash[:message]="Check email for reset link message here"
    render :template=>'account/check_email'
  end
  
  def forgot_password
    if user
      redirect_to "/"
    end
  end
  
  
  def update
    g@user = user
    @user.update(params[:user])
    unless @user.save
      #do some I didn't save stuff here
    end
    
  end
  

  #just render the registration page
  def register
    if params[:user]
       @user = User.new(params[:user])
       @user.verify_key =  generate_reset_key
       unless @user.save
          Notifier.verify(@user).deliver
          #do some I didn't save stuff here
          render :template=>'account/register'
          return
       end
       flash[:message] = @user.verify_key
        render :template=>'account/check_email'
   else
     @user = User.new()
   end
  end
  
  #check to see if the user name already exists
  def check_username
    if User.check_username(params[:user][:username])
      render :text=>"", :status=>200
    else
      render :text=>"", :status=>500
    end  
  end
  
  
  def verify
    key = params[:token]
    user = User.find_one({:verify_key=>key})
    if user
      user.verified = Time.new.to_s
      user.save
      redirect_to "/"
      return
    end
    render :template=>"account/"
    
  end
  
  
  def resend_verify
    
     @user = User.find_one({:email=>params[:email]})
     Notifier.verify(@user).deliver
      #send email
     flash[:message]="Check email for verify link message here"
     render :template=>'account/check_email'
  end
  
  
private

  def generate_reset_key
    Time.new.to_i.to_s
  end
  
 def get_user
   @user = session[:user]
 end
end
