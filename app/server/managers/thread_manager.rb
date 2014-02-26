module ThreadManager

  def create_main_thread
    @main_thread = Thread.new do
      unless @test
        Thread.stop
      end
      test_path = @test[:test_path]
      location = @test[:location]
      test_options = ServerOptions.new(@test[:doc_branch], @test[:tm_branch], location.split(' ')[0], location.split(' ')[1])
      full_start_command = start_test_on_server(test_path, test_options)    #MAIN FUNCTION
      add_data_to_history(test_path, test_options, full_start_command, @client)
      @test = nil
    end
  end

  def start_main_thread
    if @main_thread.alive?
      if @main_thread.stop?
        @main_thread.run
      end
    else
      create_main_thread
    end
  end

end