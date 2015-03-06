class DelayedRunManager

  include RunThreadManager

  def initialize
    init_runs_from_db
    create_run_scan_thread
  end

  def add_run(props, client)
    run = add_run_in_db(props, client)
    init_runs_from_db
    start_run_scan_thread
    run
  end

  def change_run(params)
    update_attributes(params)
    init_runs_from_db
  end

  def delete_run(run_id)
    delete_run_from_db(run_id)
    init_runs_from_db
  end

  def delete_runs_by_testlist_name(client, name)
    runs = client.delayed_runs.select {|run| run.name == name}
    runs.each &:destroy
  end

  def get_client_runs(client)
    client.delayed_runs
    init_runs_from_db
  end

  private

  def init_runs_from_db
    @runs = DelayedRun.all
  end

  def delete_run_from_db(id)
    run = DelayedRun.find(id)
    run.destroy
    init_runs_from_db
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
    init_runs_from_db
    run
  end

  def update_attributes(props)
    run = DelayedRun.find(props['id'])
    run.method = props['method']
    run.location = props['location']
    run.start_time = props['start_time']
    run.next_start = props['start_time']
    init_runs_from_db
    run.save
  end

end
