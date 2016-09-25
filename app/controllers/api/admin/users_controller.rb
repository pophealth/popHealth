module Api
  module Admin
    class UsersController < ApplicationController

      class Registration < Devise::RegistrationsController
        def create
          build_resource
          #if resource.save
            render :status => 200, :json => resource
          #else
          #  render :json => resource.errors, :status => :unprocessable_entity
          #end
        end
      end
      resource_description do
        resource_id 'Admin::Users'
        short 'Users Admin'
        formats ['json']
        description "This resource allows for administrative tasks to be performed on users via the API."
      end
      include PaginationHelper
      respond_to :json
      before_filter :authenticate_user!
      before_filter :validate_authorization!
      skip_before_filter :verify_authenticity_token, :only => :create

      def_param_group :pagination do
        param :page, /\d+/
        param :per_page, /\d+/
      end

      api :GET, "/admin/users", "Get a list of users."
      param_group :pagination
      formats ['json']
      example '[{"_id":"53bab4134d4d31c98d0a0000","admin":null,"agree_license":null,"approved":false,"company":"","company_url":"","disabled":false,"effective_date":null,"email":"email@email.com","first_name":"fname","last_name":"lname","npi":"","registry_id":"","registry_name":"","staff_role":true,"tin":"","username":"user"}]'
      description "Returns a paginated list of all users in the database."
      def index
        users = User.all.ordered_by_username
        render json: paginate(admin_users_path,users)
      end

      api :POST, "/admin/users/:id/promote", "Promote a user to provided role."
      param :id, String, :desc => 'The ID of the user to promote.', :required => true
      param :role, String, :desc => 'The role to promote the user to, for example staff_role or admin.', :required => true
      def promote
        toggle_privileges(params[:id], params[:role], :promote)
      end

      api :POST, "/admin/users/:id/demote", "Demote a user from provided role."
      param :id, String, :desc => 'The ID of the user to demote.', :required => true
      param :role, String, :desc => 'The role to demote the user from, for example staff_role or admin.', :required => true
      def demote
        toggle_privileges(params[:id], params[:role], :demote)
      end

      api :GET, "/admin/users/:id/enable", "Enable a users account."
      param :id, String, :desc => 'The ID of the user to enable.', :required => true
      def enable
        toggle_enable_disable(params[:id], 1)
      end

      api :GET, "/admin/users/:id/disable", "Disable a users account."
      param :id, String, :desc => 'The ID of the user to disable.', :required => true
      def disable
        toggle_enable_disable(params[:id], 0)
      end

      api :GET, "/admin/users/:id/approve", "Approve a users account."
      param :id, String, :desc => 'The ID of the user to approve.', :required => true
      def approve
        update_user(params[:id], :approved, true, "approved")
      end

      api :POST, "/admin/users/:id/update_npi", "Update users associated NPI."
      param :id, String, :desc => 'The ID of the user to update.', :required => true
      param :npi, String, :desc => 'The new NPI to assign the user to.', :required => true
      def update_npi
        update_user(params[:id], :npi, params[:npi], "updated")
      end

      api :POST, "/admin/users"
      def create
        #if request.format != :json
        #  puts request
        #  render :status => 406, :json => {:message => "The request must be json.  Your format was: " + request.format}
        #else
          Registration.new.create(request)
        #end
        #@user = User.create(params[:user])
        #if user.save
        #  render :json => @user, :status=>201
        #  return
        #else
        #  render :json => @user.errors, :status=>422
        #end
      end

      private

      def toggle_enable_disable(user_id, enable)
        enable = enable == 1
        if enable
          update_user(user_id, :disabled, false, "enabled")
        else
          update_user(user_id, :disabled, true, "disabled")
        end
      end

      def toggle_privileges(user_id, role, direction)
        if direction == :promote
          update_user(user_id, role, true, "promoted")
        else
          update_user(user_id, role, false, "demoted")
        end
      end

      def update_user(user_id, field, value, action)
        user = User.where(:id => user_id).first
        if user
          user.update_attribute(field, value)
          render status: 200, text: "User has been #{action}."
        else
          render status: 404, text: "User not found."
        end      
      end

      def validate_authorization!
        authorize! :admin, :users
      end
    end
  end
end