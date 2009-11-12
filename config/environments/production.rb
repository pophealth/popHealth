# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.action_controller.relative_url_root = ""
config.cache_classes = true

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false

XDS_HOST = "http://localhost:9080"
XDS_REGISTRY_URLS = {
  :register_stored_query         => "#{XDS_HOST}/axis2/services/xdsregistryb",
  :retrieve_document_set_request => "#{XDS_HOST}/axis2/services/xdsrepositoryb"
}
