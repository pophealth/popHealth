require 'atna'

Warden::Manager.after_authentication do |user,auth,opts|
  Atna.log(user.username, :login)
  Log.create(:username => user.username, :event => 'login')
end

Warden::Manager.before_failure do |env, opts|
  request = Rack::Request.new(env)
  attempted_login_name = request.params[:user].try(:[], :username)
  attempted_login_name ||= 'unknown'
  Atna.log(attempted_login_name, :login_failure)
  Log.create(:username => attempted_login_name, :event => 'failed login attempt')
end

Warden::Manager.before_logout do |user,auth,opts|
  Atna.log(user.username, :logout)
  Log.create(:username => user.username, :event => 'logout')
end