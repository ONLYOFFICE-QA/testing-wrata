class History < ActiveRecord::Base
  FORCE_STOP_LOG_ENTRY = 'Test on server was stopped by command'.freeze
  belongs_to :server
  belongs_to :client
  has_one :start_option

  # @return [True, False] check if test was stopped by command
  def force_stop?
    log.include?(FORCE_STOP_LOG_ENTRY)
  end

  # @return [True, False] check if
  # spec execution finished correctly, or something went wrong
  def spec_finished_correctly?
    return true if force_stop?
    total_result.include?('example')
  end

  # Send mail notification if something went wrong
  def notify_failure
    return if spec_finished_correctly?
    TestResultMailer.spec_failed_email(self).deliver_now
  end
end
