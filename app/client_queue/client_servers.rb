# frozen_string_literal: true

class ClientServers
  attr_accessor :servers_threads

  def initialize(servers_names = [])
    @servers_threads = servers_names
  end

  def servers_from_queue
    servers = []
    @servers_threads.each do |cur_node|
      servers << cur_node[:name] unless cur_node[:server_thread].server_model.book_client_id.nil?
    end
    servers
  end

  delegate :empty?, to: :@servers_threads

  def add_server(server_name, client)
    server_thread = Runner::Application.config.threads.get_thread_by_name(server_name)
    server_thread.book_server(client)
    @servers_threads << { name: server_name, server_thread: }
  end

  def delete_server(server_name)
    server_thread = Runner::Application.config.threads.get_thread_by_name(server_name)
    server_thread.unbook_server
    @servers_threads.delete(name: server_name,
                            server_thread: Runner::Application.config.threads.get_thread_by_name(server_name))
  end

  delegate :clear, to: :@servers_threads
end
