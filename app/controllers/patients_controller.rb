require_dependency 'sort_order'

class PatientsController < ApplicationController
  page_title 'Laika Test Library'
  before_filter :set_patient, :except => %w[ index create autoCreate ]
  before_filter :check_edit_permission, :only => %w[ destroy update ]

  include SortOrder
  self.valid_sort_fields = %w[ name created_at updated_at ]

  def index
    @patients      = Patient.owned_by(current_user).all :order => sort_order || "name ASC"
    @patients     += Patient.templates.all :order => sort_order || "name ASC"
    @vendor        = last_selected_vendor
    @xds_patients  = {};
    
    if LOCAL_NIST_XDS
      XdsRecordUtility.all_patients.each do |x| 
        @xds_patients[ x.patient ] = x if x.patient
      end
    end
  end

  def copy
    @patient = @patient.clone
    @patient.user = current_user
    @patient.save!
    redirect_to @patient
  rescue ActiveRecord::Error => e
    flash[:error] = "Failed to copy patient record: #{e}"
    redirect_to patients_url
  end
  
  def autoCreate
    create_random_records
    #@patient = Patient.new    
    #@patient.randomize()
    #@patient.user = current_user
    #@patient.save!
    #redirect_to patient_url(@patient)
  end
  
  # creates the given number of "realistic" patient records
  def create_random_records
    i=0
    # number = params[:number]
    while i<= 343
      patient = Patient.new
      patient.randomize()
      patient.save!
      i += 1
    end
    
    redirect_to patient_url(patient)
  end

  def create
    @patient = Patient.new(params[:patient])
    @patient.user = current_user
    @patient.save!
    redirect_to patient_url(@patient)
  rescue ActiveRecord::RecordInvalid => e
    flash[:notice] = e.to_s
    redirect_to patients_url
  end
  
  def show
    if @patient.test_plan_id 
      @show_dashboard = true
    else
      @show_dashboard = false
    end
    respond_to do |format|
      format.html 
      format.xml  do
        xml = Builder::XmlMarkup.new(:indent => 2)
        xml.instruct!
        send_data @patient.to_c32(xml),
          :filename => "#{@patient.id}.xml",
          :type => 'application/x-download'
      end
    end
  end

  def set_no_known_allergies
    @patient.update_attribute(:no_known_allergies, true)
    render :partial => '/allergies/no_known_allergies'
  end
  
  def set_pregnant
    @patient.update_attribute(:pregnant, true)
  end
  
  def set_not_pregnant
    @patient.update_attribute(:pregnant, false)
  end
  
  def destroy
    @patient.destroy
    redirect_to patients_url
  end

  def edit_template_info
    render :layout => false
  end

  def update
    if @patient.update_attributes(params[:patient])
      render :partial => 'template_info'
    else
      render :action => 'edit_template_info', :layout => false
    end
  end

  protected

  def set_patient
    @patient = Patient.find(params[:id])
  end

  def check_edit_permission
    if not @patient.editable_by?(current_user)
      redirect_to patients_url
    end
  end
end
