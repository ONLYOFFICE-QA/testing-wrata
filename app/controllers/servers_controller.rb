class ServersController < ApplicationController

  def show_current_results
    server_thread = $threads.get_thread_by_name(params[:server])
    @rspec_result = server_thread.get_full_results_of_test
    @file_name = server_thread.test_name

    render 'history/show_html_results', :layout => false
  end

  def clear_history
    server = Server.find_by_name(params[:server])
    history = server.histories
    history.delete_all

    render nothing: true
  end

  def show_more
    server = params['server']
    showed = params['showed']

    server = Server.find_by_name(server)
    @history = server.histories.order('created_at DESC').limit(10).offset(showed.to_i)
    @controller = :server

    render :layout => false
  end

  def reboot
    $threads.get_thread_by_name(params['server']).reboot

    render :nothing => true
  end

  def server_history
    server = Server.find_by_id(params[:id])
    @name = server.name
    @history = server.histories.order('created_at DESC').limit(10)
    @controller = :server

    respond_to do |format|
      format.html # history.erb
      format.json { render json: @history }
    end
  end

end
