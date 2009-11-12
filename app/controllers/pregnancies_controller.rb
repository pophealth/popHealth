class PregnanciesController < PatientChildrenController

  def edit
  end

  def update
    @patient.update_attributes(:pregnant => (params[:pregnant] == 'on'))
    render :partial  => 'show'
  end
  
  def destroy
    @patient.update_attributes(:pregnant => nil)
    render :partial  => 'show'
  end

end
