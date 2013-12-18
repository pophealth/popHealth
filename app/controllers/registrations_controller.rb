class RegistrationsController < Devise::RegistrationsController
  wrap_parameters :user, format: [:json]

  unless (APP_CONFIG['allow_user_update'])
    before_filter :authorize_user_update
    skip_before_filter :require_no_authentication
  end

  # Need bundle info to display the license information
  def new
    @bundles = Bundle.all() || []
    super
  end

  def create
    @bundles = Bundle.all() || []
    super
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
      respond_with resource
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

end
