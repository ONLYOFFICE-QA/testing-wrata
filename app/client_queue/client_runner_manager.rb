# frozen_string_literal: true

class ClientRunnerManager
  TIME_FOR_SCAN = 15

  attr_reader :client

  def initialize(client)
    @client = client
    @client_test_queue = ClientTestQueue.new
    init_servers
  end

  def check_client_for_start
    return unless ready_to_start?

    @client_servers.servers_threads.each do |server|
      next unless server[:server_thread].free?

      next_test = @client_test_queue.shift_test
      server[:server_thread].start_test(next_test) if next_test
    end
  end

  def init_servers
    servers = Server.where(book_client_id: client.id).to_a
    client_servers = []
    servers.each do |server|
      client_servers << { name: server.name,
                          server_thread: Runner::Application.config.threads.get_thread_by_name(server.name) }
    end
    @client_servers = ClientServers.new(client_servers)
  end

  def booked_servers
    @client_servers.servers_from_queue
  end

  def tests
    @client_test_queue.tests
  end

  def swap_tests(test_id1, test_id2, in_start)
    @client_test_queue.swap_tests(test_id1, test_id2, in_start)
  end

  def change_test_location(test_id, new_location)
    @client_test_queue.change_test_location(test_id, new_location)
  end

  def clear_booked_servers
    @client_servers.clear
  end

  def clear_test_queue
    @client_test_queue.clear
  end

  def shuffle_test
    @client_test_queue.shuffle
  end

  def remove_duplicates
    @client_test_queue.remove_duplicates
  end

  def add_test(test, branch, location,
               params = {})
    spec_language = params[:spec_language] || Rails.application.config.default_spec_language
    spec_language = Array(spec_language)
    test = Array(test)
    test.reverse_each do |current_test|
      spec_language.each do |current_lang|
        @client_test_queue.push_test(current_test, branch, location,
                                     spec_browser: params.fetch(:spec_browser, SpecBrowser::DEFAULT),
                                     spec_language: current_lang,
                                     to_begin_of_queue: params.fetch(:to_begin_of_queue, true),
                                     tm_branch: params[:tm_branch],
                                     doc_branch: params[:doc_branch])
      end
    end
  end

  def add_server(server_name)
    @client_servers.add_server(server_name, client)
  end

  def delete_test(test_id)
    @client_test_queue.delete_test(test_id)
  end

  def delete_server(server_name)
    @client_servers.delete_server(server_name)
  end

  def delete_all_servers
    booked_servers = @client_servers.servers_threads.pluck(:name)
    booked_servers.each do |current_name|
      delete_server(current_name)
    end
  end

  def ready_to_start?
    !(@client_test_queue.empty? || @client_servers.empty?)
  end
end
