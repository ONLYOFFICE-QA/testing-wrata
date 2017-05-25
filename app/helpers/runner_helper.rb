module RunnerHelper
  def directory_hash(path, name = nil)
    data = { data: (name || path) }
    data[:children] = children = []
    data[:path] = path
    Dir.foreach(path).sort.each do |entry|
      next if entry.start_with?('.')
      full_path = File.join(path, entry)
      children << if File.directory?(full_path)
                    directory_hash(full_path, entry)
                  else
                    { name: entry, path: full_path }
                  end
    end
    data
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
