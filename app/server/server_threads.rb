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
    self
  end

  def get_thread_by_name(name)
    @server_threads.find { |thread| thread.server_model.name == name }
  end

  def get_threads_by_user(client)
    @server_threads.select { |thread| thread.server_model.book_client_id == client.id }
  end

  def all_servers_from_threads
    Server.sort_servers(@server_threads.inject([]) { |acc, elem| acc << elem.server_model })
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

  def destroy_unbooked_servers
    @server_threads.each do |server_thread|
      next unless server_thread.server_model.book_client_id.nil?
      next unless server_thread.server_model._status == :created
      begin
        server_thread.server_model.cloud_server_destroy
        Runner::Application.config.run_manager.managers.each do |current_manager|
          current_manager.delete_server(server_thread.server_model.name)
        end
      rescue => e
        Rails.logger.error("Server: #{server_thread.server_model.name}, cannot be destroyed because of: #{e}")
      end
    end
  end

  def destroy_inactive_servers
    @server_threads.each do |server_thread|
      next unless server_thread.should_be_destroyed?
      Rails.logger.info("Server: #{server_thread.server_model.name}, doomed to be destroyed")
      begin
        server_thread.server_model.cloud_server_destroy
        Runner::Application.config.run_manager.managers.each do |current_manager|
          current_manager.delete_server(server_thread.server_model.name)
        end
      rescue => e
        Rails.logger.error("Server: #{server_thread.server_model.name}, cannot be destroyed because of: #{e}")
      end
    end
  end
end
