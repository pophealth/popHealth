class UserObserver < ActiveRecord::Observer

  def after_save(user)
    UserNotifier.deliver_forgot_password(user) if user.recently_forgot_password?
  end
  
end
