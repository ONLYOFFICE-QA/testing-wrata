Rails.application.config.delayed_runs = DelayedRunManager.new
Rails.application.config.run_manager = RunnerManagers.new
Rails.application.config.threads = ServerThreads.new.init_threads
Rails.application.config.server_destroyer = ServerDestroyerWorker.new.start_thread
