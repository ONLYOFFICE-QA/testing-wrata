module RunThreadManager

  INFELICITY = 2*60  # 2 min update interval
  DAY_TIME = 24*60*60
  WEEK_TIME = 7*24*60*60

  def create_run_scan_thread
    @run_scan_thread = Thread.new do
      while true
        Thread.stop if @runs.empty?
        @runs.delete_if do |run|
          method_timing run
        end
        puts '.....'
        sleep 5
      end
    end
  end

  def start_run_scan_thread
    if @run_scan_thread.alive?
      if @run_scan_thread.stop?
        @run_scan_thread.run
      end
    else
      create_log_scan_thread
    end
  end

  def add_to_queue(run)
    puts ' '
    puts '===================================================='
    puts '=========== START TEST ============================='
    puts '===================================================='
    puts ' '
    manager = $run_managers.find_manager_by_client_login(run.client.login)
    case run.f_type
      when 'file'
        #@test_list = run.client.test_lists.find_by_name()
        #manager.add_test(tests, branch, location)
      when 'test_list'
        test_list = run.client.test_lists.find_by_name(run.name)
        names = test_list.test_files.inject([]) do |arr, test_file|
          arr << test_file.name
        end
        manager.add_tests(names, test_list.branch, run.location)
      else

    end if manager
  end

  private

  def method_timing(run)
    method = run[:method]
    case
      when method.match(/once/)
        if check_time run.start_time
          add_to_queue run
          delete_from_db run
        end
      when method.match(/hours/), method.match(/minutes/)
        if check_each_round run
          add_to_queue run
          hours, minutes = match_minutes_and_hours(method)
          move_next_start_on(run, hours, minutes)
        end
      else
        fail "Don't know check_method: #{run.method}"
    end
  end

  def match_minutes_and_hours(method)
    hours = method.match(/_(\d*)_hours/)
    hours = hours.captures.first if hours
    minutes = method.match(/_(\d*)_minutes/)
    minutes = minutes.captures.first if minutes
    return hours, minutes
  end

  def check_each_round(run)
    if run.next_start
      check_time(run.next_start)
    else
      check_time(run.start_time)
    end
  end

  def check_time(time_to_run)
    now = Time.now
    run_datetime = time_to_run.to_time
    if now.strftime('%d/%m/%y') == run_datetime.strftime('%d/%m/%y')
      puts 'MINUS TIME: ' + (now - run_datetime).abs.to_s
      ((now - run_datetime).abs <= INFELICITY) or (run_datetime < now)
    else
      run_datetime < now
    end
  end

  def delete_from_db(run)
    puts ' '
    puts '====================================================='
    puts '=========== DELETE TEST ============================='
    puts '====================================================='
    puts ' '
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
    puts ' '
    puts '====================================================='
    puts '=========== UPDATE RUN INFO ========================='
    puts '=========== OLD TIME: ' + old_time.to_s + ' =============='
    puts '=========== NEW TIME: ' + time.to_s + ' =================='
    puts '=========== UPDATE RUN INFO ========================='
    puts '====================================================='
    puts ' '
    run.update_attributes(next_start: time)
    false
    #
  end

  def time_to_sec(hours, minute)
    hours*60*60 + minute*60
  end

end

class TestRunClass

  include RunThreadManager

  def initialize(runs = [])
    @runs = runs
  end

end