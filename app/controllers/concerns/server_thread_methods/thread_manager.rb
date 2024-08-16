# frozen_string_literal: true

module ServerThreadMethods
  module ThreadManager
    def create_main_thread
      @main_thread = Thread.new(caller: method(__method__).owner.to_s) do
        loop do
          Thread.stop unless @test
          test_path = @test[:test_path]
          clear_log_file
          @server_model.update_column(:executing_command_now, true)
          test_options = StartOption.from_test(@test)
          start_time = DateTime.now
          client = server_model.booked_client
          full_start_command = generate_full_start_command(test_path, test_options)
          exit_status = execute_command(full_start_command)
          add_data_to_history(test_path,
                              test_options,
                              full_start_command,
                              client,
                              start_time:,
                              exit_code: exit_status)
          @server_model.update_column(:executing_command_now, false)
          @server_model.update_column(:last_activity_date, Time.current)
          last_log_data
          delete_log_file
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
end
