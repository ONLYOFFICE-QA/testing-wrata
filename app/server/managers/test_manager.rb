require 'process_exists'

module TestManager
  TEST_SPOT_USER_NAME = 'nct-at'.freeze

  # Determine which command is used to run test
  # @return [String] command to run test. Empty if not supported.
  def command_executioner(test)
    return 'rspec' if test.end_with?('_spec.rb')
    return 'ruby' if test.end_with?('rb')
    ''
  end

  # Set environment options to test
  # @param options [ServerOptions] options of run
  # @return [String] bash string
  def env_variables_options(options)
    env_variables = 'export DISPLAY=:0.0'
    env_variables += " && export SPEC_SERVER_IP='#{options.portal_type}'" if options.on_custom_portal?
    env_variables
  end

  def start_test_on_server(test_path, options)
    full_start_command = generate_run_test_command(test_path.gsub('~', '$HOME'), options)
    @ssh_pid = Process.spawn(full_start_command,
                             out: [server_log_path, 'w'],
                             err: [server_log_path, 'w'])
    Process.wait(@ssh_pid)
    full_start_command
  end

  def generate_ssh_command(command)
    'ssh -o ConnectTimeout=10 -o StrictHostKeyChecking=no '\
    "#{TEST_SPOT_USER_NAME}@#{@server_model.address} <<'SSHCOMMAND'\n#{command}\nSSHCOMMAND"
  end

  def docker_command(command)
    docker_keys = '--privileged=true '\
                  '--rm '\
                  '--shm-size=512m'
    'docker rm -f $(docker ps -a -q); '\
    'docker pull onlyofficetestingrobot/nct-at-testing-node; '\
    "docker run #{docker_keys} onlyofficetestingrobot/nct-at-testing-node "\
    "bash -c \"bash /before-run.sh; #{command}\""
  end

  def docker_ssh_command(command)
    generate_ssh_command(docker_command(command))
  end

  def stop_test
    system(generate_ssh_command('docker stop -t 0 $(docker ps -q)'))
    Process.kill('KILL', @ssh_pid) if Process.exists?(@ssh_pid)
  end

  def generate_run_test_command(test, options)
    docker_ssh_command('source ~/.rvm/scripts/rvm; '\
                       "#{options.create_options}; "\
                       "#{open_folder_with_project(test)} && "\
                       "#{env_variables_options(options)} && "\
                       "#{command_executioner(test)} '#{test}' #{save_to_html} 2>&1; "\
                       "#{kill_all_browsers_on_server}")
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

  def reboot
    stop_test
    system "ssh name:#{@server_model.comp_name} -x #{TEST_SPOT_USER_NAME} \"reboot\""
  end
end

module Process
  def self.alive?(pid)
    Process.getpgid(pid)
  rescue Errno::ESRCH
    false
  end
end
