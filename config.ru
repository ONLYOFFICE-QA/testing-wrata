# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
run Runner::Application
$delayed_runs = DelayedRunManager.new
$run_managers = RunnerManagers.new