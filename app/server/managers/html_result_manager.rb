module HTMLResultManager
  def rspec_html_result_path
    "/mnt/data_share/RunnerLogs/#{@server_model.name}.html"
  end

  def html_result_exist?
    File.exist?(rspec_html_result_path)
  end

  def save_to_html
    " --format html -o #{rspec_html_result_path}"
  end

  def delete_html_result
    if html_result_exist?
      File.delete(rspec_html_result_path)
    end
  end

  def get_final_results_from_html
    total_result = ''
    if html_result_exist?
      total_result = ResultParser.get_total_result_of_rspec_html(rspec_html_result_path)
      if total_result == ''                                                                    #
        sleep 0.5                                                                              # Иногда не успевает проставить, поэтому
        total_result = ResultParser.get_total_result_of_rspec_html(rspec_html_result_path)     # нужно подождать пока rspec проставит
      end                                                                                      #
    end
    total_result
  end

  def get_test_progress
    processing = '0'
    if @test
      if html_result_exist?
        begin
          processing_from_html = ResultParser.get_processing_of_rspec_html(rspec_html_result_path)
          unless processing_from_html == ''
            processing = processing_from_html
          end
        rescue

        end
      end
    end
    processing
  end

  def create_progress_scan_thread
    @progress_scan_thread = Thread.new(caller: method(__method__).owner.to_s) do
      loop do
        unless @test
          Thread.stop
        end
        @test_progress = get_test_progress
        sleep TIME_FOR_UPDATE
      end
    end
  end

  def start_progress_scan_thread
    if @progress_scan_thread.alive?
      if @progress_scan_thread.stop?
        @progress_scan_thread.run
      end
    else
      create_progress_scan_thread
    end
  end

  def get_full_results_of_test
    results = nil
    if @test
      if html_result_exist?
        begin
          results = ResultParser.parse_rspec_html(rspec_html_result_path)
        rescue
          results = nil
        end
      end
    end
    results
  end
end
