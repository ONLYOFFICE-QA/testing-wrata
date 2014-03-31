#encoding: UTF-8
#class Queue
#  def get_queue
#    @que
#  end
#end

class ServerThread

  include HistoryManager
  include HTMLResultManager
  include LogManager
  include PingManager
  include TestManager
  include ThreadManager

  attr_accessor :server_model

  attr_reader :client

  TIME_FOR_UPDATE = 15

  def initialize(server_model)
    @server_model = server_model
    @client = nil
    @test = nil
    delete_html_result
    create_main_thread
    start_pinging_server
    create_progress_scan_thread
    create_log_scan_thread
    set_default_props
  end

  def change_model(server_model)
    @server_model = server_model
  end

  def free?
    @test ? false : true
  end

  def booked?
    @client ? true : false
  end

  def book_server(client)
    @client = client
  end

  def unbook_server
    @client = nil
  end

  def start_test(test)
    @test = test
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
        progress: @test_progress
    } if @test
    server_info[:booked] = {
        booked_client: @client.login,
        booked_by_client: @client == current_client
    } if @client
    server_info[:status] = @status
    server_info[:log] = @log
    server_info
  end

  def slice_project_path(file_name)
    file_name = file_name.slice((file_name.rindex('/') + 1)..-1)
    if file_name.include?(':')
      file_name = file_name[0..file_name.index(':')]
    end
    file_name
  end

  def test_name
    @test[:test_name]
  end

  def reboot
    stop_test
    system "ssh name:#{@server_model.comp_name} -x #{@server_model.name} \"reboot\""
  end

end


