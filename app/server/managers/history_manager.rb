module HistoryManager
  def save_start_options_in_db(history_db_line, options, start_command)
    start_options = StartOption.new
    start_options.history = history_db_line
    start_options.docs_branch = options.docs_branch
    start_options.teamlab_branch = options.teamlab_branch
    start_options.shared_branch = options.shared_branch
    start_options.teamlab_api_branch = options.teamlab_api_branch
    start_options.portal_type = options.portal_type
    start_options.portal_region = options.portal_region
    start_options.start_command = start_command
    start_options.spec_language = options.spec_language
    Runner::Application.config.threads.lock.synchronize { start_options.save }
  end

  def add_data_to_history(test, options, start_command, client_line_db, start_time: nil)
    history_line_db = save_run_history_in_db(test, client_line_db, start_time: start_time)
    save_start_options_in_db(history_line_db, options, start_command)
  end

  def save_run_history_in_db(last_test, client_line_db, start_time: nil)
    history = History.new
    history.file = last_test
    history.client = client_line_db unless client_line_db.nil?
    history.server = @server_model
    history.total_result = final_results_from_html
    history.log = full_log
    history.start_time = start_time
    if html_result_exist?
      file = File.open(rspec_html_result_path, 'r', &:read)
      history.data = file
    end
    Runner::Application.config.threads.lock.synchronize { history.save }
    history.notify_failure
    history
  end
end
