class RegistrationsController < Devise::RegistrationsController
  def new
    @bundles = mongo['bundles'].find() || []
    super
  end
  
  def create
    @bundles = mongo['bundles'].find() || []
    super
  end
end