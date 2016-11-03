# TODO: Remove workaround for starting Threads on `rake db:schema:load`
unless File.basename($PROGRAM_NAME) == 'rake'
  Rails.application.config.delayed_runs = DelayedRunManager.new
  Rails.application.config.run_managers = RunnerManagers.new
  Rails.application.config.threads = ServerThreads.new.init_threads
  Rails.application.config.server_destroyer = ServerDestroyerWorker.new.start_thread
end
