require 'server_thread'
class ServerThreads < ActionController::Base
  attr_accessor :lock

  def init_threads
    @lock = Mutex.new
    @server_threads = []
    servers = Server.sort_servers(Server.all)
    servers.each do |server_model|
      @server_threads << ServerThread.new(server_model)
    end
    @lock = Mutex.new
  end

  def get_thread_by_name(name)
    @server_threads.find { |thread| thread.server_model.name == name }
  end

  def get_threads_by_user(client)
    @server_threads.select { |thread| thread.server_model.book_client_id == client.id }
  end

  def all_servers_from_threads
    Server.sort_servers(@server_threads.inject([]) { |a, e| a << e.server_model })
  end

  def update_models
    servers = Server.all
    servers.each do |current_server|
      @server_threads.each do |current_thread|
        next unless current_server.id == current_thread.server_model.id
        current_thread.server_model = current_server
      end
    end
  end

  def add_threads
    new_servers = Server.sort_servers(Server.all)
    old_servers = all_servers_from_threads
    difference = new_servers - old_servers
    difference.each do |server|
      @server_threads << ServerThread.new(server)
    end
  end

  def delete_threads
    new_servers = Server.sort_servers(Server.all)
    old_servers = all_servers_from_threads
    difference = old_servers - new_servers
    difference.each do |diff_model|
      @server_threads.delete_if do |thread|
        thread.server_model == diff_model
      end
    end
  end
end
