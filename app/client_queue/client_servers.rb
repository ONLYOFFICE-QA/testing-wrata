class ClientServers
  attr_accessor :servers_threads

  def initialize(servers_names = [])
    @servers_threads = servers_names
  end

  def get_servers_from_queue
    servers = []
    @servers_threads.each do |cur_node|
      servers << cur_node[:name]
    end
    servers
  end

  def empty?
    @servers_threads.empty?
  end

  def add_server(server_name, client)
    server_thread = $threads.get_thread_by_name(server_name)
    unless server_thread.booked?
      server_thread.book_server(client)
      @servers_threads << { name: server_name, server_thread: server_thread }
    end
  end

  def delete_server(server_name, client)
    server_thread = $threads.get_thread_by_name(server_name)
    if server_thread.client == client
      server_thread.unbook_server
      @servers_threads.delete(name: server_name, server_thread:  ($threads.get_thread_by_name(server_name)))
    end
  end

  def get_server_by_name(server_name)
    server = nil
    @servers_threads.each do |current|
      server = current[:server_thread] if current[:name] == server_name
    end
    server
  end

  def clear
    @servers_threads.clear
  end
end
