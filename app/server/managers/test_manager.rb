module TestManager
  def start_test_on_server(test_path, options)
    full_start_command = generate_run_test_command(test_path, options)
    pid = Process.spawn(full_start_command, out: [server_log_path, 'w'])
    Process.wait(pid)
    full_start_command
  end

  def stop_test
    system "ssh -o StrictHostKeyChecking=no #{@server_model.name}@#{@server_model.address} \"killall -9 git;killall -9 ruby; killall -9 rspec; #{kill_all_browsers_on_server}\""
  end

  def generate_run_test_command(test, options)
    "ssh -o StrictHostKeyChecking=no #{@server_model.name}@#{@server_model.address} \"source ~/.rvm/scripts/rvm; source /usr/local/rvm/scripts/rvm; #{options.create_options}; #{open_folder_with_project(test)} && export DISPLAY=:0.0 && rspec '#{test}' #{save_to_html}; #{kill_all_browsers_on_server}\" 2>&1"
  end

  def open_folder_with_project(test_path)
    if test_path.include? DOCS_PROJECT_NAME
      "cd #{DOCS_PATH_WITHOUT_HOME}"
    elsif test_path.include? TEAMLAB_PROJECT_NAME
      "cd #{TEAMLAB_PATH_WITHOUT_HOME}"
    end
  end

  def kill_all_browsers_on_server
    'killall chrome 2>&1; killall firefox 2>&1; killall opera 2>&1'
  end
end

module Process
  def self.alive?(pid)
    Process.getpgid(pid)
  rescue Errno::ESRCH
    false
  end
end
