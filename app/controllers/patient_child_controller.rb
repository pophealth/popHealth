#
# This controller is an abstract class that provides basic CRUD operations for
# patient data sections. Individual actions can be overridden as needed.
#
# This controller is meant to be subclassed by controllers that a single patient
# child instance (e.g., support, advance_directive). For controllers that handle
# multiple children (e.g., conditions, allergies, providers) should subclass
# PatientChildrenController.
#
class PatientChildController < ApplicationController
  before_filter :find_patient
  before_filter :check_edit_permissions
  layout false

  def new
    instance_variable_set instance_var_name, model_class.new
    render :action => 'edit'
  end
  
  def edit
    instance_variable_set instance_var_name, @patient.send(association_name)
  end

  def create
    instance = model_class.new params[association_name]
    @patient.send "#{association_name}=", instance
    render :partial  => 'show', :locals => {association_name => instance, :patient => @patient}
  end

  def update
    instance = @patient.send(association_name)
    instance.update_attributes(params[association_name])
    render :partial  => 'show', :locals => {association_name => instance, :patient => @patient}
  end

  def destroy
    @patient.send(association_name).destroy
    render :partial  => 'show', :locals => {association_name => nil, :patient => @patient}
  end
  
  protected

  def base_name
    @base_name ||= self.class.name.sub(/Controller$/,'')
  end

  def model_class
    @model_class ||= base_name.singularize.constantize
  end

  def association_name
    @association_name ||= base_name.underscore.singularize.to_sym
  end

  def instance_var_name
    @instance_var_name ||= "@#{association_name}"
  end

  def find_patient
    if params[:patient_id]
      @patient = Patient.find params[:patient_id]
    end
    redirect_to patients_url unless @patient
  end

  def check_edit_permissions
    if not @patient.editable_by? current_user
      flash[:error] = "You are not permitted to edit this patient template."
      redirect_to @patient
    end
  end

end
