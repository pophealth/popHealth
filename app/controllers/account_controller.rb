class AccountController < ApplicationController
  include RailsWarden::Mixins::HelperMethods
  include RailsWarden::Mixins::ControllerOnlyMethods
  before_filter :authenticate!  , :only=> [:update, :login]
  
  def login
    if logged_in?
      redirect_to "/"
    end
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
    @user = user
    @user.update(params[:user])
    unless @user.save
      #do some I didn't save stuff here
    end
  end

  # Create the user and log them in
  def create
    @user = User.new(params[:user])
    if ((params[:user][:password] == params[:password_confirmation]) && @user.save)
      user = @user
      redirect_to '/'
    else
      render :template => 'register'
    end
  end


  #just render the registration page
  def register
    @user = User.new()
  end
  
  #check to see if the user name already exists
  def check_username
    if User.check_username(params[:user][:username])
      render :text=>"", :status=>200
    else
      render :text=>"", :status=>500
    end  
  end
  
  def bad_login
    render :template => 'unauthenticated'
  end
end
