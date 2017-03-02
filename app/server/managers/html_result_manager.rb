module HTMLResultManager
  RSPEC_HTML_LOGS_FOLDER = '/mnt/data_share/RunnerLogs'.freeze

  def rspec_html_result_path
    "#{RSPEC_HTML_LOGS_FOLDER}/#{@server_model.name}.html"
  end

  def html_result_exist?
    File.exist?(rspec_html_result_path)
  end

  def save_to_html
    # TODO: fix absolute path to formatter
    " --format HtmlWithPassedTime --require ~/RubymineProjects/SharedFunctional/helpers/rspec/formatter/html_with_passed_time.rb -o #{rspec_html_result_path}"
  end

  def delete_html_result
    File.delete(rspec_html_result_path) if html_result_exist?
  end

  def final_results_from_html
    total_result = ''
    if html_result_exist?
      total_result = OnlyofficeRspecResultParser::ResultParser.get_total_result_of_rspec_html(rspec_html_result_path)
      if total_result == ''                                                                    #
        sleep 0.5                                                                              # Sometimes haven't time for check
        total_result = OnlyofficeRspecResultParser::ResultParser.get_total_result_of_rspec_html(rspec_html_result_path) # so need to wait while rspec to check
      end #
    end
    total_result
  end

  def test_progress
    processing = '0'
    if @test
      if html_result_exist?
        begin
          processing_from_html = OnlyofficeRspecResultParser::ResultParser.get_processing_of_rspec_html(rspec_html_result_path)
          processing = processing_from_html unless processing_from_html == ''
        rescue StandardError => e
          Rails.logger.error e.message
          Rails.logger.error e.backtrace.join("\n")
        end
      end
    end
    processing
  end

  def test_failed_count
    processing = '0'
    if @test
      if html_result_exist?
        begin
          processing_from_html = OnlyofficeRspecResultParser::ResultParser.get_failed_cases_count_from_html(rspec_html_result_path)
          processing = processing_from_html unless processing_from_html == ''
        rescue StandardError => e
          Rails.logger.error e.message
          Rails.logger.error e.backtrace.join("\n")
        end
      end
    end
    processing
  end

  def create_progress_scan_thread
    @progress_scan_thread = Thread.new(caller: method(__method__).owner.to_s) do
      loop do
        Thread.stop unless @test
        @test_progress = test_progress
        @test_failed_count = test_failed_count
        sleep TIME_FOR_UPDATE
      end
    end
  end

  def start_progress_scan_thread
    if @progress_scan_thread.alive?
      @progress_scan_thread.run if @progress_scan_thread.stop?
    else
      create_progress_scan_thread
    end
  end

  def full_results_of_test
    results = nil
    if @test
      if html_result_exist?
        begin
          results = OnlyofficeRspecResultParser::ResultParser.parse_rspec_html(rspec_html_result_path)
        rescue StandardError => e
          Rails.logger.error e.message
          Rails.logger.error e.backtrace.join("\n")
          results = nil
        end
      end
    end
    results
  end
end
