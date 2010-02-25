class ErrorMailer < ActionMailer::Base
  public
  def errormail(exception, trace, session, params, env, sent_on = Time.now)
    content_type "text/html"
    @recipients         = ERROR_EMAIL
    @from               = "no-reply@projectpophealth.org"
    @subject            = "[Error] exception in #{env['REQUEST_URI']}" 
    @sent_on            = sent_on
    @body["exception"]  = exception
    @body["trace"]      = trace
    @body["session"]    = session
    @body["params"]     = params
    @body["env"]        = env
  end
end
