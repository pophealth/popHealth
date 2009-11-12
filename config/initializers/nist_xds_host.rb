# Point to the official NIST XDS test server unless the XDS constants have
# already been specified (see config/environments/production.rb).
if not defined?(XDS_HOST)
  XDS_HOST = "http://129.6.24.109:9080"
  XDS_REGISTRY_URLS = {
    :register_stored_query         =>"#{XDS_HOST}/tf5/services/xdsregistryb",
    :retrieve_document_set_request =>"#{XDS_HOST}/tf5/services/xdsrepositoryb"
  }
end

if not defined?(LOCAL_NIST_XDS)
  
  #if ActiveRecord::Base.configurations['nist_xds_registry']
  #  LOCAL_NIST_XDS = true
  #else
    LOCAL_NIST_XDS = false
  #end
end