Apipie.configure do |config|
  config.app_name                = "popHealth"
  config.api_base_url            = "/api"
  config.doc_base_url            = "/apipie"
  config.default_version         = "3.0"
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/api/*.rb"
  config.app_info                = <<-EOS
  API documentation for popHealth. This API is used by the web front end of popHealth but
  it can also be used to interact with patient information and clinical quality measure
  calculations from external applications.
EOS
end
