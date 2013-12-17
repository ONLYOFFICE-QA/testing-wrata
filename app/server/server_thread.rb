#encoding: UTF-8
class Queue
  def get_queue
    @que
  end
end

module Process
  def self.alive?(pid)
    begin
      Process.getpgid(pid)
    rescue Errno::ESRCH
      false
    end
  end
end

class ServerThread

  attr_reader :thread,
              :current_test,
              :run_client,
              :name,
              :log_live,
              :server,
              :status,
              :log,
              :options,
              :first_start,
              :comp_name

  attr_accessor :new_file

  def initialize(name, comp_name, server)
    @name = name
    @comp_name = comp_name
    @server = server
    @first_start = true
    default_prop
    create_thread
    pinging_server
    start_log_scanner
  end

  def default_prop
    @queue = Queue.new
    @log_live = false
    @current_test = DEFAULT_CURRENT_TEST
    @run_client = DEFAULT_RUN_CLIENT
    @pid = nil
    @prefer_pid = nil
    @test_list = false
    @log_end = 0
    @log = EMPTY_STRING
  end

  def create_thread
    @thread = Thread.new do
      while true
        if @queue.empty?
          Thread.stop
        end
        test_with_options = @queue.pop
        @first_start = false
        @current_test = slice_project_path(test_with_options[:test])
        client_line_db = test_with_options[:client]
        @run_client = get_client_name(client_line_db)
        @options = test_with_options[:options]
        delete_last_html
        clear_log
        full_start_command = generate_run_test_command(test_with_options[:test], @options)
        @pid = Process.spawn(full_start_command, :out => ["#{SERVERS_LOGS_PATH}/#{@name}.txt", 'w'])
        @log_live = true
        run_log_scanner
        @new_file = true
        Process.wait(@pid)
        init_last_time_log
        @pid = nil
        history_line_db = add_data_to_history(client_line_db)
        save_start_options(history_line_db, @options, full_start_command)
        @log_live = false
        @current_test = DEFAULT_CURRENT_TEST
        @run_client = DEFAULT_RUN_CLIENT
      end
    end
  end

  def save_start_options(history_db_line, options, start_command)
    start_options = StartOption.new
    start_options.history = history_db_line
    start_options.docs_branch = options.docs_branch
    start_options.teamlab_branch = options.teamlab_branch
    start_options.shared_branch = options.shared_branch
    start_options.teamlab_api_branch = options.teamlab_api_branch
    start_options.portal_type = options.portal_type
    start_options.portal_region = options.portal_region
    start_options.start_command = start_command
    unless start_options.save
      error = start_options.errors.full_messages
      p error
    end
  end

  def add_data_to_history(client_line_db)
    history = History.new
    history.file = @current_test
    history.client = client_line_db unless client_line_db.nil?
    history.server = @server
    history.total_result = get_total_result_from_html
    history.log = get_full_log
    if File.exist?(html_path)
      file = File.open(html_path, 'r') { |io| io.read }
      history.data = file
    end
    unless history.save
      error = history.errors.full_messages
      p error
    end
    history
  end

  def clear_log
    @log_end = 0
    @log = ''
    File.open("#{SERVERS_LOGS_PATH}/#{@name}.txt", 'w') {|f| f.write('') }
  end

  def clear_browser_log
    return false unless @prefer_pid || @pid
    if @prefer_pid != @pid
      true
    else
      false
    end
  end

  def stop_current
    if @pid && Process.alive?(@pid)
      kill_all_process_on_sever
    end
  end

  def exit_thread
    if @pid && Process.alive?(@pid)
      kill_all_process_on_sever
    end
    default_prop
  end

  def kill_all_process_on_sever
    system "knife ssh name:#{@comp_name} -x #{@name} \"killall -9 git;killall -9 ruby; killall -9 rspec; #{kill_all_browsers}\""
  end

  def kill_all_browsers
    'killall chrome 2>&1; killall firefox 2>&1; killall opera 2>&1'
  end

  def rerun_thread
    exit_thread
    create_thread
  end

  def options_hash
    if @options
      @options.to_hash
    else
      nil
    end
  end

  def slice_project_path(file_name)
    file_name = file_name.slice((file_name.rindex('/') + 1)..-1)
    if file_name.include?(':')
      file_name = file_name[0..file_name.index(':')]
    end
    file_name
  end

  def add_to_queue(test, options, client)
    @queue << {test: test, options: options, client: client}
    if @thread.alive?
      if @thread.stop?
        @thread.run
        @thread.join 0.01
      end
    else
      create_thread
    end
  end

  def generate_run_test_command(test, options)
    go_to_project = ''
    if test.include? DOCS_PROJECT_NAME
      go_to_project = "cd #{DOCS_PATH_WITHOUT_HOME}"
    elsif test.include? TEAMLAB_PROJECT_NAME
      go_to_project = "cd #{TEAMLAB_PATH_WITHOUT_HOME}"
    end
    "knife ssh name:#{@comp_name} -x #{@name} \"source ~/.rvm/scripts/rvm; #{options.create_options}; #{go_to_project} && export DISPLAY=:0.0 && rspec '#{test}' #{save_to_html}; #{kill_all_browsers}\""
  end

  def save_to_html
    " --format html -o #{html_path}"
  end

  def html_path
    "/mnt/data_share/RunnerLogs/#{@name}.html"
  end

  def delete_last_html
    if File.exist?(html_path)
      File.delete(html_path)
    end
  end

  def get_total_result_from_html
    total_result = ''
    if File.exist?(html_path)
      total_result = ResultParser.get_total_result_of_rspec_html(html_path)
      if total_result == ''                                                       #
        sleep 0.5                                                                 # Иногда не успевает проставить, поэтому
        total_result = ResultParser.get_total_result_of_rspec_html(html_path)     # нужно подождать пока rspec проставит
      end                                                                         #
    end
    total_result
  end

  def queue_count
    @queue.size
  end

  def pinging_server
    address = @server.address
    Thread.new do
      while true
        command = "ping -w1 -c1 #{address}"
        r, w = IO.pipe
        pid = spawn(command, :out => w)
        Process.wait pid
        w.close
        status = r.read.include?('0 received')
        @status = !status
        sleep(10)
      end
    end
  end

  def get_queue
    @queue.get_queue
  end

  def run_log_scanner
    if @log_scanner.alive?
      if @log_scanner.stop?
        @log_scanner.run
        @log_scanner.join 0.01
      end
    else
      start_log_scanner
    end
  end

  def get_processing_of_test
    processing = '0'
    if @log_live
      if File.exist?("/mnt/data_share/RunnerLogs/#{@name}.html")
        processing_from_html = ResultParser.get_processing_of_rspec_html("/mnt/data_share/RunnerLogs/#{@name}.html")
        unless processing_from_html == ''
          processing = processing_from_html
        end
      end
    end
    processing
  end

  def get_current_results
    results = nil
    if @log_live
      if File.exist?("/mnt/data_share/RunnerLogs/#{@name}.html")
        results = ResultParser.parse_rspec_html("/mnt/data_share/RunnerLogs/#{@name}.html")
      end
    end
    results
  end

  def start_log_scanner
    @log_scanner = Thread.new do
      while true
        init_last_time_log
        sleep 10
        unless @log_live
          Thread.stop
        end
      end
    end
  end

  def reboot
    kill_all_process_on_sever
    system "knife ssh name:#{@comp_name} -x #{@name} \"reboot\""
  end

  def init_last_time_log
    unless @first_start
      lines = IO.readlines("#{SERVERS_LOGS_PATH}/#{@name}.txt")
      if @log_end == lines.size
        return EMPTY_STRING
      end
      @log_end = @log_end - 1 unless @log_end == 0
      @log = EMPTY_STRING
      lines[@log_end..-1].each do |line|
        unless empty_line?(line)
          @log += delete_comp_name_from_line line
        end
      end
      @log_end = lines.size
    end
  end

  def get_full_log
    if File.exist? ("#{SERVERS_LOGS_PATH}/#{@name}.txt")
      lines = IO.readlines("#{SERVERS_LOGS_PATH}/#{@name}.txt")
      log = EMPTY_STRING
      lines.each do |line|
        unless empty_line?(line)
          log += delete_comp_name_from_line line
        end
      end
      return log
    end
    EMPTY_STRING
  end

  def empty_line?(line)
    line == "#{@name} \r\n"
  end

  def delete_comp_name_from_line(line)
    line.gsub("#{@name} ", '')
  end

  def get_client_name(client)
    if client.nil?
      GUEST_NAME
    else
      client.login
    end
  end

end
#
#pid = 0
#Thread.new do
#  pid = Process.spawn("knife ssh name:nct-at6 -x nct-at6 \"source ~/.rvm/scripts/rvm; cd ~/RubymineProjects/OnlineDocuments && git reset --hard && git pull && git checkout -f develop && git pull && bundle install && cd ~/RubymineProjects/SharedFunctional && git reset --hard && git pull && git checkout -f master && git pull && bundle install && cd ~/RubymineProjects/TeamLab && git reset --hard && git pull && git checkout -f feature/for_runner && git pull && bundle install && cd ~/RubymineProjects/TeamLabAPI2 && git reset --hard && git pull && git checkout -f master && git pull && sed -i \"s/@create_portal = false/@create_portal = true/g\" ~/RubymineProjects/OnlineDocuments/Data/PortalData.rb && sed -i \"s/@create_portal_domain = '.info'/@create_portal_domain = '.info'/g\" ~/RubymineProjects/OnlineDocuments/Data/PortalData.rb && sed -i \"s/@create_portal_domain = '.com'/@create_portal_domain = '.info'/g\" ~/RubymineProjects/OnlineDocuments/Data/PortalData.rb && sed -i \"s/@create_portal_region = 'us'/@create_portal_region = 'us'/g\" ~/RubymineProjects/OnlineDocuments/Data/PortalData.rb && sed -i \"s/@create_portal_region = 'eu'/@create_portal_region = 'us'/g\" ~/RubymineProjects/OnlineDocuments/Data/PortalData.rb && sed -i \"s/@@portal_type = '.info'/@@portal_type = '.info'/g\" ~/RubymineProjects/TeamLab/Framework/StaticDataTeamLab.rb && sed -i \"s/@@portal_type = '.com'/@@portal_type = '.info'/g\" ~/RubymineProjects/TeamLab/Framework/StaticDataTeamLab.rb && sed -i \"s/@@server_region = 'us'/@@server_region = 'us'/g\" ~/RubymineProjects/TeamLab/Framework/StaticDataTeamLab.rb && sed -i \"s/@@server_region = 'eu'/@@server_region = 'us'/g\" ~/RubymineProjects/TeamLab/Framework/StaticDataTeamLab.rb && sed -i \"s/@@server_region= 'us'/@@server_region= 'us'/g\" ~/RubymineProjects/TeamLab/Framework/StaticDataTeamLab.rb && sed -i \"s/@@server_region= 'eu'/@@server_region= 'us'/g\" ~/RubymineProjects/TeamLab/Framework/StaticDataTeamLab.rb  ; cd ~/RubymineProjects && export DISPLAY=:0.0 && rspec '~/RubymineProjects/TeamLab/Rspec/Calendar/Smoke/Calendar_Mini_Smoke_spec.rb'\"")
#  Process.wait(pid)
#  p 10
#end
#
#sleep 2
##system 'knife ssh name:nct-at6 -x nct-at6 "kill -9 -1"'
#system 'knife ssh name:nct-at6 -x nct-at6 "pkill git;pkill ruby; pkill rspec"'
#system 'knife ssh name:nct-peat6 -x nct-at6 "pkill git;pkill ruby; pkill rspec"'
#sleep 10
#p 'dasasdasd'
#
#pid = Process.spawn("knife ssh name:nct-at4 -x nct-at4 \"source ~/.rvm/scripts/rvm; cd ~/RubymineProjects/OnlineDocuments && git reset --hard && git pull && git checkout develop && git pull && bundle install; cd ~/RubymineProjects/SharedFunctional && git reset --hard && git pull && git checkout master && git pull && bundle install; cd ~/RubymineProjects/TeamLab && git reset --hard && git pull && git checkout master && git pull && bundle install; cd ~/RubymineProjects/TeamLabAPI2 && git reset --hard && git pull && git checkout master && git pull; sed -i \"s/@create_portal = true/@create_portal = false/g\" ~/RubymineProjects/OnlineDocuments/Data/PortalData.rb; sed -i \"s/@create_portal_domain = '.info'/@create_portal_domain = '.isa'/g\" ~/RubymineProjects/OnlineDocuments/Data/PortalData.rb; sed -i \"s/@create_portal_domain = '.com'/@create_portal_domain = '.isa'/g\" ~/RubymineProjects/OnlineDocuments/Data/PortalData.rb; sed -i \"s/@create_portal_region = 'us'/@create_portal_region = ''/g\" ~/RubymineProjects/OnlineDocuments/Data/PortalData.rb; sed -i \"s/@create_portal_region = 'eu'/@create_portal_region = ''/g\" ~/RubymineProjects/OnlineDocuments/Data/PortalData.rb; sed -i \"s/@@portal_type = '.info'/@@portal_type = '.isa'/g\" ~/RubymineProjects/TeamLab/Framework/StaticDataTeamLab.rb; sed -i \"s/@@portal_type = '.com'/@@portal_type = '.isa'/g\" ~/RubymineProjects/TeamLab/Framework/StaticDataTeamLab.rb; sed -i \"s/@@server_region = 'us'/@@server_region = ''/g\" ~/RubymineProjects/TeamLab/Framework/StaticDataTeamLab.rb; sed -i \"s/@@server_region = 'eu'/@@server_region = ''/g\" ~/RubymineProjects/TeamLab/Framework/StaticDataTeamLab.rb; sed -i \"s/@@server_region= 'us'/@@server_region= ''/g\" ~/RubymineProjects/TeamLab/Framework/StaticDataTeamLab.rb; sed -i \"s/@@server_region= 'eu'/@@server_region= ''/g\" ~/RubymineProjects/TeamLab/Framework/StaticDataTeamLab.rb  ; cd ~/RubymineProjects/OnlineDocuments && export DISPLAY=:0.0 && rspec '~/RubymineProjects/OnlineDocuments/RspecTest/Studio/run_test_spec.rb'; killall chrome 2>&1; killall firefox 2>&1; killall opera 2>&1\"", :out => ['logs/nct-at4.txt', 'w'])
#Process.wait pid
#
#p 3
p :alala.to_s

