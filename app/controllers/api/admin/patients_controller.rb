module Api
  module Admin
    class PatientsController < ApplicationController
      resource_description do
        resource_id 'Admin::Patients'
        short 'Patients Admin'
        formats ['json']
        description "This resource allows for the management of clinical quality measures in the popHealth application."
      end
      include ApplicationHelper
      
      before_filter :authenticate_user!
      before_filter :validate_authorization!
      skip_before_action :verify_authenticity_token

      api :GET, "/patients/count", "Get count of patients in the database"
      formats ['json']
      example '{"patient_count":56}'
      def count
        json = {}
        json['patient_count'] = Record.count
        render :json => json
      end

      api :POST, "/admin/patients", "Upload a zip file of patients."
      param :file, nil, :desc => 'The zip file of patients to upload.', :required => true
      param :practice_id, String, :desc => "ID for the patient's Practice", :required => false
      param :practice_name, String, :desc => "Name for the patient's Practice", :required => false     
      def create
        file = params[:file]
        
        practice = get_practice_parameter(params[:practice_id], params[:practice_name])
        
        FileUtils.mkdir_p(File.join(Dir.pwd, "tmp/import"))
        file_location = File.join(Dir.pwd, "tmp/import")
        file_name = "patient_upload" + Time.now.to_i.to_s + rand(1000).to_s

        temp_file = File.new(file_location + "/" + file_name, "w")

        File.open(temp_file.path, "wb") { |f| f.write(file.read) }

        Delayed::Job.enqueue(ImportArchiveJob.new({'practice' => practice, 'file' => temp_file,'user' => current_user}),:queue=>:patient_import)
        render status: 200, text: 'Patient file has been uploaded.'
      end

      api :PUT, "/patient", "Load a single patient XML file into popHealth"
      formats ['xml']
      param :file, nil, :desc => "The XML patient file", :required => true
      param :practice_id, String, :desc => "ID for the patient's Practice", :required => false
      param :practice_name, String, :desc => "Name for the patient's Practice", :required => false
      description "Upload a QRDA Category I document for a patient into popHealth."
      def upload_single_patient

        file = StringIO.new(request.body.read)
        practice = get_practice_parameter(params[:practice_id], params[:practice_name])

        FileUtils.mkdir_p(File.join(Dir.pwd, "tmp/import"))
        file_location = File.join(Dir.pwd, "tmp/import")
        file_name = "patient_upload" + Time.now.to_i.to_s + rand(1000).to_s

        temp_file = File.new(file_location + "/" + file_name, "w")

        File.open(temp_file.path, "wb") { |f| f.write(file.read) }

        begin
          response_hash = BulkRecordImporter.import_file(temp_file,File.new(temp_file).read,nil,{},practice)
          status_code = 200
        rescue
          status_code = 500
        end

        if response_hash == nil
          status_text = 'File not uploaded'
          status_code = 400
        elsif response_hash == false
          status_text = 'Patient could not be saved'
          status_code = 400
        elsif response_hash == true
          status_text = "Patient upload successful"
          status_code = 200
        else
          status_text = response_hash[:message]
          status_code = response_hash[:status_code]
        end


        render text: status_text, status: status_code
      end


      api :DELETE, "/admin/patients", "Delete all patients in the database."
      def destroy
        Record.delete_all
        render status: 200, text: 'Patient records successfully removed from database.'
      end

      private 

      def validate_authorization!
        authorize! :admin, :users
      end
    end
  end
end
