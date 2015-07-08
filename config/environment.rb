# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Runner::Application.initialize!

class Logger
  def format_message(_severity, _timestamp, _progname, msg)
    "#{Time.now.strftime('%T/%d.%m.%y')} (#{$PID}) #{msg}\n"
  end
end
