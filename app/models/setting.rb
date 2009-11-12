class Setting < ActiveRecord::Base
  def to_s; name; end

  def self.[] name
    setting = find :first, :conditions => { :name => name.to_s }
    setting ? setting.value : nil
  end

  def self.method_missing name, *args
    self[ name ] or raise NoMethodError, "no such setting `#{name}'"
  end

  # FIXME These are here to provide temporary backward compatibility for
  # constant-based global settings. They'll eventually be removed.
  def xds_repository_unique_id
    self[:xds_repository_unique_id] ||
      XDS_REPOSITORY_UNIQUE_ID
  end
  def xds_retrieve_document_set_request_url
    self[:xds_retrieve_document_set_request_url] ||
      XDS_REGISTRY_URLS[:retrieve_document_set_request]
  end
  def xds_register_stored_query_url
    self[:xds_register_stored_query_url] ||
      XDS_REGISTRY_URLS[:register_stored_query]
  end
end
