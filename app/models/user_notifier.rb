class UserNotifier < ActionMailer::Base

  # Send a password reset email to +user+.
  #
  # @param [User] user message recipient
  def forgot_password(user)
    setup_email(user)
    subject 'Request to change your Laika password'
    body :recipient => user.first_name, :url => "#{ENV['HOST_URL']}/account/reset_password/#{user.password_reset_code}" 
  end

  protected

  def setup_email(user)
    recipients  "#{user.email}" 
    from "#{ENV['HELP_LIST']}"
    sent_on Time.now
  end

end
