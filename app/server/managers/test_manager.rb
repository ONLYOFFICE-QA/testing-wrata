require 'process_exists'

module TestManager
  TEST_SPOT_USER_NAME = 'nct-at'

  # Determine which command is used to run test
  # @return [String] command to run test. Empty if not supported.
  def command_executioner(test)
    return 'rspec' if test.end_with?('_spec.rb')
    return 'ruby' if test.end_with?('rb')
    ''
  end

  def start_test_on_server(test_path, options)
    full_start_command = generate_run_test_command(test_path.gsub('~', '$HOME'), options)
    @ssh_pid = Process.spawn(full_start_command, out: [server_log_path, 'w'])
    Process.wait(@ssh_pid)
    full_start_command
  end

  def generate_ssh_command(command)
    "ssh -o ConnectTimeout=10 -o StrictHostKeyChecking=no #{TEST_SPOT_USER_NAME}@#{@server_model.address} <<'SSHCOMMAND'\n#{command}\nSSHCOMMAND"
  end

  def execute_docker_command(command)
    shm_increase = 'sudo umount /dev/shm; sudo mount -t tmpfs -o rw,nosuid,nodev,noexec,relatime,size=512M tmpfs /dev/shm;' # TODO: remove after docker implement `-shm` argument https://github.com/docker/docker/issues/2606
    generate_ssh_command("docker rm -f $(docker ps -a -q); docker pull onlyofficetestingrobot/nct-at-testing-node; docker run --privileged=true onlyofficetestingrobot/nct-at-testing-node bash -c \"#{shm_increase}sudo mount -a; #{command}\"")
  end

  def stop_test
    system(generate_ssh_command('docker stop -t 0 $(docker ps -q)'))
    Process.kill('KILL', @ssh_pid) if Process.exists?(@ssh_pid)
  end

  def generate_run_test_command(test, options)
    execute_docker_command("source ~/.rvm/scripts/rvm; #{options.create_options}; #{open_folder_with_project(test)} && export DISPLAY=:0.0 && #{command_executioner(test)} '#{test}' #{save_to_html} 2>&1; #{kill_all_browsers_on_server}")
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
