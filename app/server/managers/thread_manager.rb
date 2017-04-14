module ThreadManager
  def create_main_thread
    @main_thread = Thread.new(caller: method(__method__).owner.to_s) do
      loop do
        Thread.stop unless @test
        test_path = @test[:test_path]
        location = @test[:location]
        clear_log_file
        @server_model.update_column(:executing_command_now, true)
        test_options = ServerOptions.new(@test[:doc_branch],
                                         @test[:tm_branch],
                                         location.split(' ')[0],
                                         location.split(' ')[1],
                                         spec_language: @test[:spec_language])
        start_time = DateTime.now
        full_start_command = start_test_on_server(test_path, test_options)
        add_data_to_history(test_path, test_options, full_start_command, @client, start_time: start_time)
        @server_model.update_column(:executing_command_now, false)
        @server_model.update_column(:last_activity_date, Time.current)
        init_last_log
        delete_log_file
        delete_html_result
        @last_log_end = 0
        @test = nil
      end
    end
  end

  def start_main_thread
    if @main_thread.alive?
      @main_thread.run if @main_thread.stop?
    else
      create_main_thread
    end
  end
end
