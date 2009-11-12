#
# This controller is an abstract class that provides basic CRUD operations for
# patient data sections. Individual actions can be overridden as needed.
#
# This controller is meant to be subclassed by controllers that handle multiple
# children (e.g., conditions, allergies, providers). For controllers that handle
# only a single patient child instance, (e.g., support, advance_directive) you
# should subclass PatientChildController.
#
class PatientChildrenController < PatientChildController
  
  def edit
    instance_variable_set(instance_var_name, @patient.send(association_name).find(params[:id]))
  end
  
  def create
    instance_variable_set(instance_var_name, model_class.new(params[param_key]))
    @patient.send(association_name) << instance_variable_get(instance_var_name)
  end

  def update
    instance = @patient.send(association_name).find(params[:id])
    instance.send(:update_attributes, params[param_key])

    render :partial => 'show', :locals => {
      :patient => @patient,
      param_key     => instance
    }
  end

  def destroy
    instance = @patient.send(association_name).find(params[:id])
    instance.destroy
  end
  
  protected

  def association_name
    @association_name ||= base_name.underscore
  end

  def param_key
    @param_key ||= association_name.singularize.to_sym
  end

  def instance_var_name
    @instance_var_name ||= "@#{param_key}"
  end

end
