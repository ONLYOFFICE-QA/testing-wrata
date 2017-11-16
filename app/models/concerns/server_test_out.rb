module ServerTestOut
  BEGIN_HTML_OUT = '-----BEGIN HTML OUTPUT-----'.freeze
  END_HTML_OUT = '-----END HTML OUTPUT-----'.freeze

  # @return [Stirng] path to log of server
  def log_path
    "#{SERVERS_LOGS_PATH}/#{name}.txt"
  end

  # @return [String] html result in container
  def result_in_container
    "/var/www/html/#{name}.html"
  end

  # @return [String] command to ouput test result
  def output_result
    "echo '#{BEGIN_HTML_OUT}';" \
    "cat #{result_in_container};" \
    "echo #{END_HTML_OUT};"
  end

  # @return [String] html result not in container
  def last_test_file
    "/tmp/#{name}.html"
  end

  # @return [String] get final result of test
  def final_result_html
    full_log = File.read(log_path)
    full_log.match(/#{BEGIN_HTML_OUT}(.*)#{END_HTML_OUT}/m)[1]
  end

  # Add data to log if force stopped
  # @param result [String] current html result
  # @return [Nothing]
  def force_stop_log_append(result)
    File.open(log_path, 'a+') do |f|
      f << History::FORCE_STOP_LOG_ENTRY
      f << ServerTestOut::BEGIN_HTML_OUT
      f << result
      f << ServerTestOut::END_HTML_OUT
    end
  end
end
