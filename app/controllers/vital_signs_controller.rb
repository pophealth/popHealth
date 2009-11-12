class VitalSignsController < PatientChildrenController
  def new
    @result = VitalSign.new
    render :file => 'results/edit'
  end

  def show
    vital_sign = @patient.vital_signs.find params[:id]
    render 'results/_show.html', :locals => { :result => vital_sign, :patient => @patient }
    # XXX I'm pretty sure the below should work in rails 2.3, it's possible that a plugin is interfering.
    #render 'results/show', :result => vital_sign, :patient => @patient
  end

  def edit
    @result = @patient.vital_signs.find params[:id]
    render :file => 'results/edit'
  end

  def update
    vital_sign = @patient.vital_signs.find params[:id]
    vital_sign.update_attributes(params[:vital_sign])
    render 'results/_show.html', :locals => { :result => vital_sign, :patient => @patient }
    # XXX I'm pretty sure the below should work in rails 2.3, it's possible that a plugin is interfering.
    #render 'results/show', :result => vital_sign, :patient => @patient
  end

  def create
    @result = @patient.vital_signs.create params[:vital_sign]
    render :file => 'results/create'
  end

  def destroy
    VitalSign.find(params[:id]).destroy
    render :file => 'results/destroy'
  end
end
