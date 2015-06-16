class Example
  attr_accessor :text, :duration, :message, :backtrace, :code, :log, :passed

  def initialize(text = nil, duration = nil, message = nil, backtrace = nil, code = nil, log = nil, passed = nil)
    @text = text
    @duration = duration
    @message = message
    @backtrace = backtrace
    @code = code
    @log = log
    @passed = passed
  end
end
