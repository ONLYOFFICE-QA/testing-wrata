module LogManager
  # @return [Integer] show how much of last log shown
  LAST_LINES_COUNT = 60

  def set_default_props
    @log = EMPTY_STRING
    clear_log_file
  end

  def log_file_empty?
    if log_file_exist?
      File.zero?(@server_model.log_path)
    else
      true
    end
  end

  def log_file_exist?
    File.exist? @server_model.log_path
  end

  def create_log_file
    File.new(@server_model.log_path, 'w') if log_file_exist?
  end

  def clear_log_file
    File.open(@server_model.log_path, 'w') { |f| f.write('') } if log_file_exist?
  end

  def delete_log_file
    File.delete(@server_model.log_path) if log_file_exist?
  end

  def create_log_scan_thread
    @log_scan_thread = Thread.new(caller: method(__method__).owner.to_s) do
      loop do
        unless @test # Stop Thread if test was ended
          Thread.stop                                 #
        end
        last_log_data                                 # check each TIME_FOR_UPDATE new log
        sleep TIME_FOR_UPDATE                         #
      end
    end
  end

  def start_log_scan_thread
    if @log_scan_thread.alive?
      @log_scan_thread.run if @log_scan_thread.stop?
    else
      create_log_scan_thread
    end
  end

  def last_log_data
    if !log_file_empty?
      lines = IO.readlines(@server_model.log_path)
      @log = EMPTY_STRING                             # clear before init new log
      last_lines = lines.last(LAST_LINES_COUNT)
      last_lines.each do |line|
        next if empty_line?(line)
        @log += delete_comp_name_from_line(line)
      end
    else
      @log = EMPTY_STRING
    end
  end

  def full_log
    if log_file_exist?
      lines = IO.readlines(@server_model.log_path)
      log = EMPTY_STRING
      lines.each do |line|
        log += delete_comp_name_from_line line unless empty_line?(line)
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
