# Provides logging capability to the Windows Eventlog

module EventlogLogger

  require 'win32/eventlog'

  # Monkey-patch EventLog clas to add a new method so that Atna.log method
  # remains the same.
  class Win32::EventLog
    def notice(msg)
      report_event(:event_type => Win32::EventLog::INFO, :data => msg)
    end
  end

  def with_logger
    s = Win32::EventLog.open('Application')
    yield s
    s.close
  end
end
