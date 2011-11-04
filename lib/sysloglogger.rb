# Provides logging capability to Syslog

module SyslogLogger

  require 'syslog'

  def with_logger
    s = Syslog.open('popHealth', Syslog::LOG_PID | Syslog::LOG_CONS, Syslog::LOG_AUTH)
    yield s
    s.close
  end
end
