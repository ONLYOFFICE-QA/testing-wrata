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
    unless start_options.save
      error = start_options.errors.full_messages
      p error
    end
  end

  def add_data_to_history(test, options, start_command, client_line_db)
    history_line_db = save_run_history_in_db(test, client_line_db)
    save_start_options_in_db(history_line_db, options, start_command)
  end

  def save_run_history_in_db(last_test, client_line_db)
    history = History.new
    history.file = last_test
    history.client = client_line_db unless client_line_db.nil?
    history.server = @server_model
    history.total_result = get_final_results_from_html
    history.log = get_full_log
    if html_result_exist?
      file = File.open(rspec_html_result_path, 'r') { |io| io.read }
      history.data = file
    end
    unless history.save
      error = history.errors.full_messages
      p error
    end
    history
  end

end