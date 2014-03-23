class DelayRunController < ApplicationController

  before_action :get_manager

  def index
    @client_runs = $delayed_runs.get_client_runs(@client)
  end

  def add_run
    $delayed_runs.add_run(params, @client)

    render nothing: true
  end

  def change_time

  end

  def delete_run

  end


  private

  def get_manager
    if @client
      @manager = $run_managers.find_manager_by_client_login(@client.login)
    else
      flash[:error] = 'You need be authorized' # Not quite right!
      render signin_path
    end
  end

end