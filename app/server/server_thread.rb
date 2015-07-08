require_relative '../../app/server/managers/history_manager'
require_relative '../../app/server/managers/html_result_manager'
require_relative '../../app/server/managers/log_manager'
require_relative '../../app/server/managers/ping_manager'
require_relative '../../app/server/managers/test_manager'
require_relative '../../app/server/managers/thread_manager'

class ServerThread
  include HistoryManager
  include HTMLResultManager
  include LogManager
  include PingManager
  include TestManager
  include ThreadManager

  attr_accessor :server_model, :_status

  attr_reader :client

  TIME_FOR_UPDATE = 15

  def initialize(server_model)
    @server_model = server_model
    @client = server_model.booked_client
    @test = nil
    @_status = :normal
    delete_html_result
    create_main_thread
    start_pinging_server
    create_progress_scan_thread
    create_log_scan_thread
    set_default_props
  end

  def free?
    @test ? false : true
  end

  def booked?
    @client ? true : false
  end

  def book_server(client)
    @client = client
    server_model.book(client)
  end

  def unbook_server
    @client = nil
    server_model.unbook
  end

  def start_test(test)
    @test = test
    @time_start = Time.now
    start_progress_scan_thread
    start_log_scan_thread
    start_main_thread
  end

  def get_info_from_server(current_client)
    server_info = {}
    server_info[:name] = @server_model.name
    server_info[:test] = {
      name: slice_project_path(@test[:test_path]),
      location: @test[:location],
      progress: @test_progress,
      time: testing_time
    } if @test
    server_info[:booked] = {
      booked_client: @client.login,
      booked_by_client: @client == current_client
    } if @client
    server_info[:status] = @status
    server_info[:_status] = @server_model._status
    server_info[:log] = @log
    server_info[:server_ip] = @server_model.address
    server_info
  end

  def testing_time
    Time.at(Time.now - @time_start).utc.strftime('%H:%M')
  end

  def slice_project_path(file_name)
    file_name = file_name.slice((file_name.rindex('/') + 1)..-1)
    file_name = file_name[0..file_name.index(':')] if file_name.include?(':')
    file_name
  end

  def test_name
    @test[:test_name]
  end
end
