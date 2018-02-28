# @return [Boolean] check if db already initialized
def db_initialized?
  ActiveRecord::Base.connection.table_exists?(:servers)
end

if db_initialized?
  Rails.application.config.threads = ServerThreads.new.init_threads
  Rails.application.config.delayed_runs = DelayedRunManager.new
  Rails.application.config.run_manager = RunnerManagers.new
  Rails.application.config.server_destroyer = ServerDestroyerWorker.new.start_thread
  Rails.application.config.queue_checker = QueueCheckerWorker.new.start_thread
end
