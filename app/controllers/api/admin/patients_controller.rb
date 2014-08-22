module Api
  module Admin
    class PatientsController < ApplicationController
      resource_description do
        resource_id 'Admin::Patients'
        short 'Patients Admin'
        formats ['json']
        description "This resource allows for the management of clinical quality measures in the popHealth application."
      end
      before_filter :authenticate_user!
      before_filter :validate_authorization!
      skip_before_action :verify_authenticity_token

      api :POST, "/admin/patients", "Upload a zip file of patients."
      param :file, nil, :desc => 'The zip file of patients to upload.', :required => true
      def create
        file = params[:file]

        FileUtils.mkdir_p(File.join(Dir.pwd, "tmp/import"))
        file_location = File.join(Dir.pwd, "tmp/import")
        file_name = "patient_upload" + Time.now.to_i.to_s + rand(1000).to_s

        temp_file = File.new(file_location + "/" + file_name, "w")

        File.open(temp_file.path, "wb") { |f| f.write(file.read) }

        Delayed::Job.enqueue(ImportArchiveJob.new({'file' => temp_file,'user' => current_user}),:queue=>:patient_import)
        render status: 200, text: 'Patient file has been uploaded.'
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