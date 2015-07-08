require 'fileutils'

Thread.class_eval do
  alias_method :old_initialize, :initialize

  def initialize(*args, &block)
    args.each do |arg|
      MyLogger.write_in_file(arg[:caller], "Init new thread \n") if arg.is_a?(Hash) && arg[:caller]
    end
    old_initialize(*args, &block)
  end
end

module MyLogger
  def self.write_in_file(caller = nil, text)
    FileUtils.mkdir('/tmp/Runner') unless File.exist?('/tmp/Runner')
    File.open('/tmp/Runner/log.txt', 'a') { |f| f.write("Called from #{caller} in" + Time.now.to_s + ' | ' + text) }
  end
end
