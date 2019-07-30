# frozen_string_literal: true

class DelayedRun < ActiveRecord::Base
  INFELICITY = 2 * 60 # 2 min update interval

  belongs_to :client

  # Check if current delayed run should start in specific time
  # @param time_to_run [ActiveSupport::TimeWithZone] time in which to check for start
  # @return [True, False] should delayed run start in this time
  def should_start_by_time?(time_to_run)
    now = Time.zone.now
    run_datetime = time_to_run.to_time
    if now.strftime('%d/%m/%y') == run_datetime.strftime('%d/%m/%y')
      time_diff = (now - run_datetime).abs
      Rails.logger.info "For delay run #{self} at #{time_to_run} time left #{(time_diff / 60).to_i} minutes"
      (time_diff <= INFELICITY) || (run_datetime < now)
    else
      run_datetime < now
    end
  end

  # Convert current DelayedRun to string
  # @return [String] representation of DelayedRun
  def to_s
    "Test List: #{name}, Location: #{location}, by #{method}"
  end

  def extract_minutes_and_hours
    hours = method.match(/_(\d*)_hours/)
    hours = hours.captures.first if hours
    minutes = method.match(/_(\d*)_minutes/)
    minutes = minutes.captures.first if minutes
    [hours, minutes]
  end
end
