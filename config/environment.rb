# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

class Logger
  def format_message(_severity, _timestamp, _progname, msg)
    "#{Time.now.strftime('%T/%d.%m.%y')} (#{$PID}) #{msg}\n"
  end
end
