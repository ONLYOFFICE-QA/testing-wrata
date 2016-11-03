class ClientRunnerManager
  TIME_FOR_SCAN = 15

  attr_reader :client

  def initialize(client = nil, tests = [], servers = [])
    @client = client
    init_tests(tests)
    init_servers(servers)
    create_client_runner_thread
  end

  def create_client_runner_thread
    @client_runner_thread = Thread.new(caller: method(__method__).owner.to_s) do
      loop do
        Thread.stop unless ready_to_start?
        @client_servers.servers_threads.each do |server|
          next unless server[:server_thread].free?
          next_test = @tests.shift_test
          server[:server_thread].start_test(next_test) if next_test
        end
        sleep TIME_FOR_SCAN
      end
    end
  end

  def start_client_runner_thread
    if @client_runner_thread.alive?
      @client_runner_thread.run if @client_runner_thread.stop?
    else
      create_client_runner_thread
    end
  end

  def init_tests(tests)
    @tests = ClientTestQueue.new(tests)
  end

  def init_servers(servers)
    servers = Server.where(book_client_id: client.id).to_a
    client_servers = []
    servers.each do |server|
      client_servers << { name: server.name, server_thread: $threads.get_thread_by_name(server.name) }
    end
    @client_servers = ClientServers.new(client_servers)
  end

  def booked_servers
    @client_servers.servers_from_queue
  end

  def tests
    @tests.tests
  end

  def swap_tests(test_id1, test_id2, in_start)
    @tests.swap_tests(test_id1, test_id2, in_start)
  end

  def change_test_location(test_id, new_location)
    @tests.change_test_location(test_id, new_location)
  end

  def clear_booked_servers
    @client_servers.clear
  end

  def clear_test_queue
    @tests.clear
  end

  def shuffle_test
    @tests.shuffle
  end

  def remove_duplicates
    @tests.remove_duplicates
  end

  def add_test(test, branch, location)
    @tests.push_test(test, branch, location)
    start_client_runner_thread if ready_to_start?
  end

  def add_tests(tests, branch, location, to_begin_of_queue: true)
    tests.reverse.each do |test|
      @tests.push_test(test, branch, location, to_begin_of_queue: to_begin_of_queue)
    end
    start_client_runner_thread if ready_to_start?
  end

  def add_test_with_branches(test, tm_branch, doc_branch, location)
    @tests.push_test_with_branches(test, tm_branch, doc_branch, location)
    start_client_runner_thread if ready_to_start?
  end

  def add_server(server_name)
    @client_servers.add_server(server_name, client)
    start_client_runner_thread if ready_to_start?
  end

  def delete_test(test_id)
    @tests.delete_test(test_id)
  end

  def delete_server(server_name)
    @client_servers.delete_server(server_name)
  end

  def delete_all_servers
    booked_servers = @client_servers.servers_threads.collect { |e| e[:name] }
    booked_servers.each do |current_name|
      delete_server(current_name)
    end
  end

  def change_tests(tests)
    @tests = ClientTestQueue.new(tests)
  end

  def change_servers(servers)
    @client_servers = ClientServers.new(servers)
  end

  def ready_to_start?
    !(@tests.empty? || @client_servers.empty?)
  end
end
