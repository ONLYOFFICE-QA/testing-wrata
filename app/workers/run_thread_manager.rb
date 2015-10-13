module RunThreadManager
  INFELICITY = 2 * 60 # 2 min update interval
  DAY_TIME = 24 * 60 * 60
  WEEK_TIME = 7 * 24 * 60 * 60

  def create_run_scan_thread
    @run_scan_thread = Thread.new(caller: method(__method__).owner.to_s) do
      loop do
        Thread.stop if @runs.empty?
        @runs.to_a.each do |run|
          method_timing run
        end
        Rails.logger.info 'Waiting for next check for delay runner'
        sleep 5
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
    manager = $run_managers.find_manager_by_client_login(run.client.login)
    case run.f_type
    when 'file'
      # @test_list = run.client.test_lists.find_by_name()
      # manager.add_test(tests, branch, location)
    when 'test_list'
      fail NoMethodError, 'You cannot add run to queue with empty name' if run.name.empty?
      test_list = run.client.test_lists.find_by_name(run.name)
      names = test_list.test_files.inject([]) do |arr, test_file|
        arr << test_file.name
      end
      manager.add_tests(names, test_list.branch, run.location)
    end if manager
  end

  private

  def method_timing(run)
    method = run[:method]
    case
    when method.match(/once/)
      if run.should_start_by_time?(run.start_time)
        add_to_queue run
        delete_from_db run
      end
    when method.match(/hours/), method.match(/minutes/)
      if check_each_round run
        add_to_queue run
        hours, minutes = BullshitHelper.match_minutes_and_hours(method)
        move_next_start_on(run, hours, minutes)
      end
    else
      fail "Don't know check_method: #{run.method}"
    end
  end

  def check_each_round(run)
    if run.next_start
      run.should_start_by_time?(run.next_start)
    else
      run.should_start_by_time?(run.start_time)
    end
  end

  def check_time(time_to_run)
    now = Time.now
    run_datetime = time_to_run.to_time
    if now.strftime('%d/%m/%y') == run_datetime.strftime('%d/%m/%y')
      time_diff = (now - run_datetime).abs
      Rails.logger.info "For delay run at #{time_to_run} time left #{time_diff} seconds"
      (time_diff <= INFELICITY) || (run_datetime < now)
    else
      run_datetime < now
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
    old_time = if run.next_start
                 run.next_start
               else
                 run.start_time
               end
    time = old_time + time_to_sec(hour.to_i, minute.to_i)
    time += time_to_sec(hour.to_i, minute.to_i) while Time.now > time
    Rails.logger.info 'move_next_start_on: update run info'
    Rails.logger.info "move_next_start_on: old time: #{old_time}, new time: #{time}"
    run.update_attributes(next_start: time)
    false
    #
  end

  def time_to_sec(hours, minute)
    hours * 60 * 60 + minute * 60
  end
end
