# frozen_string_literal: true

require 'process_exists'

module ServerThreadMethods
  module TestManager
    # Determine which command is used to run test
    # @return [String] command to run test. Empty if not supported.
    def command_executioner(test)
      return 'bundle exec rspec' if test.end_with?('_spec.rb')
      return 'ruby' if test.end_with?('rb')
      return 'bash' if test.end_with?('.sh')

      ''
    end

    # Set environment options to test
    # @param options [ServerOptions] options of run
    # @return [String] bash string
    def env_variables_options(options)
      env_variables = 'export DISPLAY=:0.0'
      unless options.spec_browser == SpecBrowser::DEFAULT
        env_variables += " && export SPEC_BROWSER='#{options.spec_browser}'"
      end
      env_variables += " && export SPEC_REGION='#{options.server_location}'"
      env_variables += " && export SPEC_LANGUAGE='#{options.spec_language}'"
      env_variables += " && export SPEC_SERVER_IP='#{options.portal_type}'" if options.on_custom_portal?
      env_variables
    end

    def generate_full_start_command(test_path, options)
      generate_run_test_command(test_path, options)
    end

    def execute_command(command)
      @ssh_pid = Process.spawn(command,
                               out: [@server_model.log_path, 'w'],
                               err: [@server_model.log_path, 'w'])
      _id, status = Process.wait2(@ssh_pid)
      status.exitstatus
    end

    def generate_ssh_command(command)
      "sshpass -p #{Rails.application.credentials.ssh_pass} " \
        'ssh -o ConnectTimeout=10 ' \
        '-o StrictHostKeyChecking=no ' \
        '-o UserKnownHostsFile=/dev/null ' \
        "#{Rails.application.credentials.ssh_user}@#{@server_model.address} " \
        "<<'SSHCOMMAND'\n#{command}\nSSHCOMMAND"
    end

    def docker_command(command)
      docker_keys = '--privileged=true ' \
                    "-h docker-on-#{@server_model.name} " \
                    '--rm ' \
                    '-p 80:80 ' \
                    "#{docker_run_environments}" \
                    '--shm-size=2g'
      'docker rm -f $(docker ps -a -q); ' \
        "docker pull #{Rails.application.config.node_docker_image}; " \
        "docker run #{docker_keys} #{Rails.application.config.node_docker_image} " \
        "bash -c \"bash /before-run.sh; chmod 777 /var/www/html/; #{command}\" " \
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
      docker_ssh_command("#{options.create_options} " \
                         "#{open_folder_with_project(test)} && " \
                         "#{env_variables_options(options)} && " \
                         "#{command_executioner(test)} '#{test}' #{save_to_html} 2>&1; " \
                         "#{@server_model.output_result}")
    end

    def open_folder_with_project(test_path)
      if test_path.include? DOCS_PROJECT_NAME
        'cd ~/RubymineProjects/OnlineDocuments'
      elsif test_path.include? TEAMLAB_PROJECT_NAME
        'cd ~/RubymineProjects/TeamLab'
      else
        path_after_projects = test_path.split('RubymineProjects/')[1]
        project_name = path_after_projects.split('/').first
        "cd ~/RubymineProjects/#{project_name}"
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
end
