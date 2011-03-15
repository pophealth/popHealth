class AccountsController < ApplicationController

  include RailsWarden::Mixins::HelperMethods
  include RailsWarden::Mixins::ControllerOnlyMethods

  before_filter :authenticate!, :only => [:update, :login, :edit]

  def login
    if logged_in?
      redirect_to "/"
    end
  end

  def reset_password
    @user = User.find_one(:email=>params[:email])
    if @user
      @user.reset_key = ActiveSupport::SecureRandom.hex(20)
      @user.save
      Notifier.reset_password(@user).deliver
      render :create
    else
      flash[:error] = "Unable to find an account with that email address"
      render :forgot_password
    end
  end

  def forgot_password
    if user
      redirect_to "/"
    end
  end

  def update
    @registration_errors = []
    @user = user
    @user.update(params[:user])
    
    if params[:password].present? && params[:password_confirmation].present?
      if params[:password] == params[:password_confirmation]
        @user.salt_and_store_password(params[:password])
      else
        @registration_errors << "Your supplied passwords did not match!"
      end
    end
    
    if @user.save
      redirect_to '/'
    else
      @user.errors.each_pair do |key, value|
        @registration_errors << key.to_s.humanize + ' ' + value.join(' and ')
      end
      
      render :edit
    end
  end

  def edit
    @user = user
  end

  def password_reset_login
    @user = User.find_one(:email => params[:email], :reset_key => params[:reset_key])
    if @user
      @user.reset_password!
      self.user = @user
      render :edit
    else
      render :text => 'Bad password reset request', :status => 403
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
    @user.salt_and_store_password(params[:user][:password])
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
      
      render :new
    end
  end

  def log_out
    logout
    redirect_to '/'
  end

  #just prepare the user object and render the registration page
  def new
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