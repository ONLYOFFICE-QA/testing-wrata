# frozen_string_literal: true

module RunThreadManager
  DAY_TIME = 24 * 60 * 60
  WEEK_TIME = 7 * 24 * 60 * 60
  CHECK_TIMEOUT = 60

  def create_run_scan_thread
    @run_scan_thread = Thread.new(caller: method(__method__).owner.to_s) do
      loop do
        @runs.to_a.each do |run|
          method_timing run
        end
        Rails.logger.info "Waiting for #{CHECK_TIMEOUT} seconds for next check for delay runs"
        sleep CHECK_TIMEOUT
      end
    end
  end

  def start_run_scan_thread
    if @run_scan_thread.alive?
      @run_scan_thread.run if @run_scan_thread.stop?
    else
      create_log_scan_thread
    end
  end

  def add_to_queue(run)
    Rails.logger.info 'add_to_queue: start test'
    manager = Runner::Application.config.run_manager.find_manager_by_client_login(run.client.login)
    return unless manager

    raise NoMethodError, 'You cannot add run to queue with empty name' if run.name.empty?

    test_list = run.client.test_lists.find_by(name: run.name)
    names = test_list.test_files.inject([]) do |arr, test_file|
      arr << test_file.name
    end
    manager.add_test(names, test_list.branch, run.location, to_begin_of_queue: false)
  end

  private

  def method_timing(run)
    method = run[:method]
    if /once/.match?(method)
      if run.should_start_by_time?(run.start_time)
        add_to_queue run
        delete_from_db run
      end
    elsif method.match(/hours/) || method.match(/minutes/)
      if check_each_round run
        add_to_queue run
        hours, minutes = run.extract_minutes_and_hours
        move_next_start_on(run, hours, minutes)
      end
    else
      raise "Don't know check_method: #{run.method}"
    end
  end

  def check_each_round(run)
    if run.next_start
      run.should_start_by_time?(run.next_start)
    else
      run.should_start_by_time?(run.start_time)
    end
  end

  def delete_from_db(run)
    Rails.logger.info 'delete_from_db: delete test'
    run.destroy
    true
  end

  def move_next_start_on(run, hour, minute)
    hour ||= 0
    minute ||= 0
    old_time = run.next_start || run.start_time
    time = old_time + time_to_sec(hour.to_i, minute.to_i)
    time += time_to_sec(hour.to_i, minute.to_i) while Time.zone.now > time
    Rails.logger.info 'move_next_start_on: update run info'
    Rails.logger.info "move_next_start_on: old time: #{old_time}, new time: #{time}"
    run.update(next_start: time)
    false
  end

  def time_to_sec(hours, minute)
    hours * 60 * 60 + minute * 60
  end
end
