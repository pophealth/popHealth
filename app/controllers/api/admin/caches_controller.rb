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

      api :GET, "/admin/caches/count", "Return count of caches in the database."
      example '{"query_cache_count":56, "patient_cache_count":100}'
      def count
        json = {}
        json['query_cache_count'] = HealthDataStandards::CQM::QueryCache.count
        json['patient_cache_count'] = PatientCache.count
        render :json => json
      end

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