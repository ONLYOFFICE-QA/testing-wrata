require 'server_thread'
class ServerThreads < ActionController::Base

  attr_accessor :lock

  def init_threads
    @lock = Mutex.new
    @server_threads = []
    servers = Server.all.sort_by {|s| s.name.split('nct-at')[1].to_i}
    servers.each do |server_model|
      @server_threads << ServerThread.new(server_model)
    end
  end

  def get_thread_by_name(name)
    @server_threads.each do |thread|
      if thread.server_model.name == name
         return thread
      end
    end
  end

  def get_all_servers_from_threads
    servers = []
    @server_threads.each do |thread|
      servers << thread.server_model
    end
    servers
  end

  # To change this template use File | Settings | File Templates.
end

$threads = ServerThreads.new
$threads.init_threads
