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
  
  def verify
    @user = User.find_one(:email => params[:email], :validation_key => params[:validation_key])
    if @user
      @user.validate_account!
      self.user = @user
      redirect_to "/"
    else
      render :text => 'Bad validation request', :status => 403
    end
  end

  # Create the user and log them in if there were no problems with the parameters
  def create
    @registration_errors = []

    if (params[:user][:password] != params[:password_confirmation])
      @registration_errors << "Your supplied passwords did not match!"
    end
    
    if (!params[:agree_license])
      @registration_errors << "You must agree to terms and conditions of use to create an account!"
    end

    @user = User.new(params[:user])
    @user.password = params[:user][:password]
    if @user.valid? && @registration_errors.empty?
      if EMAIL_VERIFICATION
        @user.validation_key = ActiveSupport::SecureRandom.hex(20)
        @user.save
        Notifier.verify(@user).deliver
      else
        @user.save
        self.user = @user
        redirect_to '/'
      end
    else
      @user.errors.each_pair do |key, value|
        @registration_errors << key.to_s.humanize + ' ' + value.join(' and ')
      end
      
      render :register
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