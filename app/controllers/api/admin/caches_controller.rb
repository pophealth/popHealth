module Api
  module Admin
    class CachesController < ApplicationController
      resource_description do
        resource_id 'Admin::Caches'
        short 'Caches Admin'
        formats ['json']
        description "This resource allows for administrative tasks to be performed on the cache via the API."
      end
      before_filter :authenticate_user!
      before_filter :validate_authorization!

      api :DELETE, "/admin/caches", "Empty all caches in the database."
      def destroy
        HealthDataStandards::CQM::QueryCache.delete_all
        PatientCache.delete_all
        render status: 200, text: 'Server caches have been emptied.'
      end

      private 

      def validate_authorization!
        authorize! :admin, :users
      end
    end
  end
end