ActionMailer::Base.delivery_method=:smtp
ActionMailer::Base.smtp_settings = {
  :address => "smtp.gmail.com",
  :port => "587",
  :domain => "gmail.com",
  :authentication => :login,
  ## can change to another account
  :user_name => "",
  :password => "",
  :enable_starttls_auto => true
}
ActionMailer::Base.perform_deliveries = true 
ActionMailer::Base.raise_delivery_errors = true 
ActionMailer::Base.default :charset => "utf-8"
ActionMailer::Base.default :content_type => "text/html"

## Change IP and port to appropriate server credentials
ActionMailer::Base.default_url_options[:host] = "192.168.0.211"
ActionMailer::Base.default_url_options[:port] = 3000
