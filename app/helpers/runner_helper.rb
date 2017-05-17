module RunnerHelper
  def directory_hash(project)
    Rails.application.config.github_helper.file_tree(project)
  end

  def get_subtest_by_path(path_to_test)
    test_file = File.new(path_to_test)
    file_tests = []
    test_file.each_with_index do |line, index|
      if line =~ /it [\'\"](.*)?[\'\"] do/
        test_name = line.scan(/it [\'\"](.*?)[\'\"] do/)
        file_tests << { name: test_name.first.first, stroke: (index + 1) }
      end
    end
    test_file.close
    file_tests
  end

  def server_booked?(server_name)
    Runner::Application.config.threads.get_thread_by_name(server_name).booked?
  end

  def client_booked?(server_name)
    Runner::Application.config.threads.get_thread_by_name(server_name).client == current_client
  end

  def check_active(project_name)
    if current_client.project == project_name
      'active'
    else
      ''
    end
  end
end
