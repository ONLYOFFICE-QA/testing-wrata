module LogManager

  def set_default_props
    @last_log_end = 0
    @log = EMPTY_STRING
    clear_log_file
  end

  def server_log_path
    "#{SERVERS_LOGS_PATH}/#{@server_model.name}.txt"
  end

  def log_file_empty?
    if log_file_exist?
      File.zero?(server_log_path)
    else
      true
    end
  end

  def log_file_exist?
    File.exist? server_log_path
  end

  def create_log_file
    if log_file_exist?
      File.new(server_log_path, 'w')
    end
  end

  def clear_log_file
    if log_file_exist?
      File.open(server_log_path, 'w') {|f| f.write('') }
    end
  end

  def delete_log_file
    if log_file_exist?
      File.delete(server_log_path)
    end
  end

  def create_log_scan_thread
    @log_scan_thread = Thread.new(caller: method(__method__).owner.to_s) do
      while true
        unless @test                       # Stop Thread if test was ended
          Thread.stop                                 #
        end
        init_last_log                                 # check each TIME_FOR_UPDATE new log
        sleep TIME_FOR_UPDATE                         #
      end
    end
  end

  def start_log_scan_thread
    if @log_scan_thread.alive?
      if @log_scan_thread.stop?
        @log_scan_thread.run
      end
    else
      create_log_scan_thread
    end
  end

  def init_last_log
    if !log_file_empty?
      lines = IO.readlines(server_log_path)
      full_size = lines.size
      if @last_log_end == full_size or full_size < @last_log_end      # return if we don't get new lines in log file
        return
      end
      @log = EMPTY_STRING                             # clear before init new log
      lines[@last_log_end..-1].each do |line|
        unless empty_line?(line)                      # check if line don't 'empty', like 'testpc-9  '
          @log += delete_comp_name_from_line line     # delete testpc-9(and etc.) from log line
        end
      end
      @last_log_end = full_size                      # init new end of log
    else
      @log = EMPTY_STRING
    end
  end

  def get_full_log
    if log_file_exist?
      lines = IO.readlines(server_log_path)
      log = EMPTY_STRING
      lines.each do |line|
        unless empty_line?(line)
          log += delete_comp_name_from_line line
        end
      end
      return log
    end
    EMPTY_STRING
  end

  def empty_line?(line)
    line == "#{@server_model.name} \r\n"
  end

  def delete_comp_name_from_line(line)
    line.gsub("#{@server_model.name} ", '')
  end

end

#File.open('loh.txt', 'w')
p File.dirname(__FILE__)