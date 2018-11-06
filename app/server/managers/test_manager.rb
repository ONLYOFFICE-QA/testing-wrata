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
    env_variables += " && export SPEC_BROWSER='#{options.spec_browser}'" unless options.spec_browser == SpecBrowser::DEFAULT
    env_variables += " && export SPEC_LANGUAGE='#{options.spec_language}'"
    env_variables += " && export SPEC_SERVER_IP='#{options.portal_type}'" if options.on_custom_portal?
    env_variables
  end

  def generate_full_start_command(test_path, options)
    generate_run_test_command(test_path.gsub('~', '$HOME'), options)
  end

  def execute_command(command)
    @ssh_pid = Process.spawn(command,
                             out: [@server_model.log_path, 'w'],
                             err: [@server_model.log_path, 'w'])
    _id, status = Process.wait2(@ssh_pid)
    status.exitstatus
  end

  def generate_ssh_command(command)
    'ssh -o ConnectTimeout=10 -o StrictHostKeyChecking=no '\
    "#{TEST_SPOT_USER_NAME}@#{@server_model.address} <<'SSHCOMMAND'\n#{command}\nSSHCOMMAND"
  end

  def docker_command(command)
    docker_keys = '--privileged=true '\
                  "-h docker-on-#{@server_model.name} "\
                  '--rm '\
                  '-p 80:80 '\
                  "#{docker_run_environments}"\
                  '--shm-size=2g'
    'docker rm -f $(docker ps -a -q); '\
    "docker pull #{Rails.application.config.node_docker_image}; "\
    "docker run #{docker_keys} #{Rails.application.config.node_docker_image} "\
    "bash -c \"bash /before-run.sh; sudo chmod 777 /var/www/html/; #{command}\" " \
  end

  def docker_ssh_command(command)
    generate_ssh_command(docker_command(command))
  end

  def stop_test
    current_result = read_progress
    system(generate_ssh_command('docker stop -t 0 $(docker ps -q)'))
    Process.kill('KILL', @ssh_pid) if Process.exists?(@ssh_pid)
    @server_model.force_stop_log_append(current_result)
  end

  def generate_run_test_command(test, options)
    docker_ssh_command("#{options.create_options}; "\
                       "#{open_folder_with_project(test)} && "\
                       "#{env_variables_options(options)} && "\
                       "#{command_executioner(test)} '#{test}' #{save_to_html} 2>&1; "\
                       "#{@server_model.output_result}")
  end

  def open_folder_with_project(test_path)
    if test_path.include? DOCS_PROJECT_NAME
      "cd #{DOCS_PATH_WITHOUT_HOME}"
    elsif test_path.include? TEAMLAB_PROJECT_NAME
      "cd #{TEAMLAB_PATH_WITHOUT_HOME}"
    end
  end

  private

  def docker_run_environments
    run_param = ''
    env_file_content = Client.find(client.id).env_file
    env_file_content.each_line do |current_env|
      run_param += "--env #{current_env.strip} "
    end
    run_param
  end
end
