class RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters, if: :devise_controller?
  wrap_parameters :user, format: [:json]

  unless (APP_CONFIG['allow_user_update'])
    before_filter :authorize_user_update
    skip_before_filter :require_no_authentication
  end

  skip_before_filter :verify_authenticity_token, :only => :create

  # Need bundle info to display the license information
  def new
    @bundles = Bundle.all() || []
    super
  end

  def create
    if (request.content_type =~ /json/)
      build_resource sign_up_params
      if resource.save
         render :status => 200, :json => resource
      else
        render :json => resource.errors, :status => :unprocessable_entity
      end
    else 
      @bundles = Bundle.all() || []
      super
    end
  end

  # modified to avoid redirecting if responding via JSON
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    if update_resource(resource, params)
      yield resource if block_given?
      if is_flashing_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
          :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      sign_in resource_name, resource, :bypass => true
      respond_to do |format|
        format.html { redirect_to after_update_path_for(resource) }
        format.json { render json: resource }
      end
    else
      clean_up_passwords resource
      respond_to do |format|
        format.html { render action: "edit" }
        format.json { render nothing: true, status: :not_acceptable }
      end
    end
  end

  # If this is an AJAX request, just update the attributes; if this is an HTML request, update the attributes unless password or current_password are present.
  def update_resource(resource, params)
    params = params[resource_name]
    if request.xhr? || !(params[:password].present? || params[:current_password].present?)
      # remove passwords from params
      resource.update_attributes(params.reject { |k, v| %w(password password_confirmation current_password).include? k })
    else
      resource.update_with_password(params)
    end
  end

  protected

  def after_inactive_sign_up_path_for(resource)
    '/approval_needed.html'
  end

  def authorize_user_update
    authorize! :manage, resource
  end

  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email, :username, :password, :password_confirmation, :company, :company_url, :provider_id, :practice_id, :registry_name, :registry_id, :npi, :tin, :agree_license, :approved, :staff_role)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:first_name, :last_name, :email, :username, :password, :password_confirmation, :company, :company_url, :provider_id, :practice_id, :registry_name, :registry_id, :npi, :tin, :agree_license, :approved, :staff_role) }
  end
end