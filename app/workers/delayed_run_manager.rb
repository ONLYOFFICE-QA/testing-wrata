class DelayedRunManager

  include RunThreadManager

  def initialize
    init_runs_from_db
    #create_run_scan_thread
  end

  def add_run(props, client)
    run = add_run_in_db(props, client)
    init_runs_from_db
    start_run_scan_thread
    run
  end

  def change(params)
    update_attributes(params)
    init_runs_from_db
  end

  def delete_run(run_id)
    @runs.find(run_id).delete
    init_runs_from_db
  end

  def get_client_runs(client)
    client.delayed_runs
  end

  private

  def init_runs_from_db
    @runs = DelayedRun.all
  end

  def add_run_in_db(props, client)
    run = DelayedRun.new
    run.client = client
    run.method = props['method']
    run.f_type = props['f_type']
    run.name = props['name']
    run.location = props['location']
    run.start_time = props['start_time']
    run.save
    run
  end

  def update_attributes(props)
    run = DelayedRun.find(props['id'])
    run.method = props['method']
    run.location = props['location']
    run.start_time = props['start_time']
    run.save
  end

end

$delayed_runs = DelayedRunManager.new
