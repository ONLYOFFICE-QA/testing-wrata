class QueueController < ApplicationController
  before_action :manager

  def book_server
    @manager.add_server(params['server'])

    render nothing: true
  end

  def unbook_server
    @manager.delete_server(params['server'])

    render nothing: true
  end

  def add_test
    @manager.add_test(params['test_path'], params['branch'], params['location'])

    render nothing: true
  end

  def add_tests
    @manager.add_tests(params['tests_path'], params['branch'], params['location'])

    render nothing: true
  end

  def retest
    @manager.add_test_with_branches(params['test_path'], params['tm_branch'], params['doc_branch'], params['location'])

    render nothing: true
  end

  def delete_test
    @manager.delete_test(params['test_id'].to_i)

    render nothing: true
  end

  def clear_tests
    @manager.clear_test_queue

    render nothing: true
  end

  def clear_booked_servers
    @manager.clear_booked_servers

    render nothing: true
  end

  def swap_tests
    @manager.swap_tests(params['test_id1'].to_i, params['test_id2'].to_i, params['in_start'])

    render nothing: true
  end

  def change_test_location
    @manager.change_test_location(params['test_id'].to_i, params['new_location'])

    render nothing: true
  end

  private

  def manager
    if @client
      @manager = $run_managers.find_manager_by_client_login(@client.login)
    else
      flash[:empty_pages] = 'You need be authorized' # Not quite right!
      render signin_path
    end
  end
end
