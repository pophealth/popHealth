class RegistrationsController < Devise::RegistrationsController
  wrap_parameters :user, format: [:json]

  unless (APP_CONFIG['allow_user_update'])
    before_filter :authorize_user_update
    skip_before_filter :require_no_authentication
  end

  # Need bundle info to display the license information
  def new
    @bundles = Bundle.find() || []
    super
  end

  def create
    @bundles = Bundle.find() || []
    super
  end

  # Lets the account info be updated (like tax id) without changing
  # the password
  def update
    # Devise use update_with_password instead of update_attributes.
    # This is the only change we make.
    if resource.update_attributes(params[resource_name])
      respond_to do |format|
        # Line below required if using Devise >= 1.2.0
        sign_in resource_name, resource, :bypass => true
        format.html do
          set_flash_message :notice, :updated
          redirect_to after_update_path_for(resource)
        end
        format.json { render json: resource }
      end
    else
      respond_to do |format|
        clean_up_passwords(resource)
        format.html { render_with_scope :edit }
        format.json { render json: { errors: @model.errors.full_messages, status: :unprocessable_entity } }
      end
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
