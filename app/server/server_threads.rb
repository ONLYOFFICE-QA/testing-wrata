require 'server_thread'
class ServerThreads < ActionController::Base

  def init_threads
    @server_threads = []
    Server.all.each do |server|
      #unless user.name == AMAZON_SERVER_NAME
        @server_threads << ServerThread.new(server.name, server.comp_name, server)
      #end
    end
  end

  def get_thread_by_name(name)
    @server_threads.each do |thread|

  def get_all_servers_from_threads
    servers = []
    @server_threads.each do |thread|
      servers << thread.server
    end
    servers
  end

      if thread.name == name
         return thread
      end
    end
  end

  def get_all_servers_from_threads
    servers = []
    @server_threads.each do |thread|
      servers << thread.server
    end
    servers
  end

  # To change this template use File | Settings | File Templates.
end

$threads = ServerThreads.new
$threads.init_threads
