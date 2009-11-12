class AllergiesController < PatientChildrenController

  def create
    super
    @patient.update_attribute(:no_known_allergies, false)
  end
  
  def destroy
    super
    
    if @patient.allergies.empty?
      render :partial => "no_known_allergies_link", :locals=>{:patient=>@patient}
    end
  end
end
