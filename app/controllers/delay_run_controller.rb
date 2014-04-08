class DelayRunController < ApplicationController

  before_action :get_manager

  def index
    @client_runs = $delayed_runs.get_client_runs(@client)
    if @client.test_lists.empty?
      render 'empty_pages#empty_test_list'
    end
  end

  def add_run
    @run = $delayed_runs.add_run(params, @client)

    render layout: false
  end

  def change_run
    $delayed_runs.change_run(params)

    render nothing: true
  end

  def delete_run

  end

  def add_delayed_row
    render :layout => false
  end

  private

  def get_manager
    if @client
      @manager = $run_managers.find_manager_by_client_login(@client.login)
    else
      flash[:empty_pages] = 'You need be authorized' # Not quite right!
      render signin_path
    end
  end

end