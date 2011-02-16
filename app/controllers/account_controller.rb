class AccountController < ApplicationController

  include RailsWarden::Mixins::HelperMethods
  include RailsWarden::Mixins::ControllerOnlyMethods

  before_filter :authenticate!, :only=> [:update, :login]

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

  # Create the user and log them in if there were no problems with the parameters
  def create

    @registration_errors = Array.new()
    if (!params[:user][:password])
      @registration_errors << "You didn't supply a password!"
      errors = true
    end

    if (params[:user][:password] != params[:password_confirmation])
      @registration_errors << "Your supplied passwords did not match!"
      errors = true
    end
    
    if (params[:user][:password].length < 5)
      @registration_errors << "Passwords must be at least 5 characters long!"
      errors = true
    end

    if (!params[:user][:username] || params[:user][:username].length < 1)
      @registration_errors << "You didn't provide a user name!"
      errors = true
    end

    if (params[:user][:username].length < 5)
      @registration_errors << "Your user name must be at least 5 characters long!"
      errors = true
    end

    if (!params[:user][:email] || params[:user][:email].length < 1)
      @registration_errors << "You didn't provide an email address!"
      errors = true
    end

    if (User.find_one({:email => params[:user][:email]}))
      @registration_errors << "That email address already exists in system!"
      errors = true
    end

    if (!params[:agree_license])
      @registration_errors << "You must agree to terms and conditions of use to create an account!"
      errors = true
    end

    @user = User.new(params[:user])
    if errors == true
      render :register
    else
      @user.save
      self.user = @user
      redirect_to '/'
    end
  end

  def log_out
    logout
    redirect_to '/'
  end

  #just prepare the user object and render the registration page
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