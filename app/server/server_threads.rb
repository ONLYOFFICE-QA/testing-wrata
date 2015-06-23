require 'server_thread'
class ServerThreads < ActionController::Base
  attr_accessor :lock

  def init_threads
    @lock = Mutex.new
    @server_threads = []
    servers = Server.all_sorted
    servers.each do |server_model|
      @server_threads << ServerThread.new(server_model)
    end
    @lock = Mutex.new
  end

  def get_thread_by_name(name)
    @server_threads.find { |thread| thread.server_model.name == name }
  end

  def all_servers_from_threads
    @server_threads.inject([]) { |a, e| a << e.server_model }
  end

  def update_models
    servers = Server.all_sorted
    @server_threads.each_with_index do |server_thread, i|
      server_thread.server_model = servers[i]
    end
  end

  def add_threads
    new_servers = Server.all_sorted
    old_servers = @server_threads.inject([]) { |a, e| a << e.server_model }
    difference = new_servers - old_servers
    difference.each do |server|
      @server_threads << ServerThread.new(server)
    end
  end

  def delete_threads
    new_servers = Server.all_sorted
    old_servers = @server_threads.inject([]) { |a, e| a << e.server_model }
    difference = old_servers - new_servers
    difference.each do |diff_model|
      @server_threads.delete_if do |thread|
        thread.server_model == diff_model
      end
    end
  end
end
