class QueueController < ApplicationController
  before_action :manager

  def book_server
    return head(:forbidden) unless able_to_be_booked?
    @manager.add_server(params['server'])

    render body: nil
  end

  def unbook_server
    @manager.delete_server(params['server'])

    render body: nil
  end

  def unbook_all_servers
    @manager.delete_all_servers

    render body: nil
  end

  def add_test
    @manager.add_test(params['test_path'], params['branch'], params['location'],
                      spec_language: params['spec_language'],
                      tm_branch: params['teamlab_branch'],
                      doc_branch: params['doc_branch'])

    render body: nil
  end

  def retest
    @manager.add_test(params['test_path'], params['branch'], params['location'],
                      spec_language: params['spec_language'],
                      tm_branch: params['tm_branch'],
                      doc_branch: params['doc_branch'])

    render body: nil
  end

  def delete_test
    @manager.delete_test(params['test_id'].to_i)

    render body: nil
  end

  def clear_tests
    @manager.clear_test_queue

    render body: nil
  end

  def shuffle_tests
    @manager.shuffle_test

    render body: nil
  end

  def remove_duplicates
    @manager.remove_duplicates

    render body: nil
  end

  def clear_booked_servers
    @manager.clear_booked_servers

    render body: nil
  end

  def swap_tests
    @manager.swap_tests(params['test_id1'].to_i, params['test_id2'].to_i, params['in_start'])

    render body: nil
  end

  def change_test_location
    @manager.change_test_location(params['test_id'].to_i, params['new_location'])

    render body: nil
  end

  private

  def manager
    if current_client
      @manager = Runner::Application.config.run_manager.find_manager_by_client_login(current_client.login)
    else
      flash[:empty_pages] = 'You need be authorized' # Not quite right!
      render signin_path
    end
  end

  # @return [true, false] is server able to be booked
  def able_to_be_booked?
    server = Server.find_by_name(params['server'])
    server.book_client_id.nil?
  end
end
