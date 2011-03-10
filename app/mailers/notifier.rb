class Notifier < ActionMailer::Base
  default :from => "noreply@pophealth.org"

  def reset_password(user)
    @user = user
    mail(:to => user.email)
  end

  def verify(user)
    @user = user
    mail(:to => user.email, :subject => 'popHealth Account Verification')
  end
end
