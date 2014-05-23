Warden::Manager.after_authentication do |user,auth,opts|
  Log.create(:username => user.username, :event => 'login')
end

Warden::Manager.before_failure do |env, opts|
  request = Rack::Request.new(env)
  attempted_login_name = request.params[:user].try(:[], :username)
  attempted_login_name ||= 'unknown'
  Log.create(:username => attempted_login_name, :event => 'failed login attempt')
end

Warden::Manager.before_logout do |user,auth,opts|
  #this has a chance of getting called with a nil user, in which case we skip logging
  #TODO: figure out why this has a chance of getting called with a nil user (only happens from 403 page)
  if user
    Log.create(:username => user.username, :event => 'logout')
  end
end