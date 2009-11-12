class VendorsController < ApplicationController
  page_title 'Laika Vendor Inspections'
  before_filter :find_vendor, :only => [:update, :destroy]

  def create
    vendor = Vendor.new(params[:vendor])
    vendor.user = current_user
    if vendor.save
      flash[:notice] = "Vendor inspection ID was successfully created."
    else
      flash[:notice] = "Failed to create a new vendor inspection ID: #{vendor.errors.full_messages.join(', ')}."
    end
    redirect_to vendor_test_plans_url(@vendor)
  end

  def update
    if not @vendor.update_attributes(params[:vendor])
      flash[:notice] = "Failed to rename vendor inspection ID: #{@vendor.errors.full_messages.join(', ')}."
    end
    redirect_to vendor_test_plans_url(@vendor)
  end

  def destroy
    @vendor.destroy
    flash[:notice] = "The vendor inspection ID has been deleted."
    redirect_to patients_url
  end

  private

  def find_vendor
    @vendor = current_user.vendors.find_by_id(params[:id])
    redirect_to patients_url if @vendor.nil?
  end
end
