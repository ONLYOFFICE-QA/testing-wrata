class ServersController < ApplicationController
  # GET /test_lists
  # GET /test_lists.json
  def index
    @servers = Server.sort_servers(Server.all)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @servers }
    end
  end

  # GET /clients/1
  # GET /clients/1.json
  def show
    @server = Server.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @server }
    end
  end

  # GET /servers/new
  def new
    @server = Server.new
  end

  # GET /servers/1/edit
  def edit
    @server = Server.find(params[:id])
  end

  def show_current_results
    server_thread = Runner::Application.config.threads.get_thread_by_name(params['server'])
    @rspec_result = server_thread.full_results_of_test
    @file_name = server_thread.test_name

    render 'histories/show_html_results', layout: false
  end

  def clear_history
    server = Server.find_by_name(params['server'])
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

    return render nothing: true if @history.empty?
    render layout: false
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

  def create
    @server = Server.new(server_params)

    if @server.save
      Runner::Application.config.threads.add_threads
      redirect_to @server
    else
      render 'new'
    end
  end

  # PUT /clients/1
  # PUT /clients/1.json
  def update
    @server = Server.find(params[:id])

    respond_to do |format|
      if @server.update_attributes(server_params)
        Runner::Application.config.threads.update_models
        format.html { redirect_to @server, notice: 'Server was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render 'edit' }
        format.json { render json: @server.errors, status: :unprocessable_entity }
      end
    end
  end

  def cloud_server_create
    server = Runner::Application.config.threads.get_thread_by_name(params['server'])
    server.server_model.cloud_server_create(params['size'])
    Runner::Application.config.threads.update_models
    render nothing: true
  end

  def cloud_server_fetch_ip
    server = Runner::Application.config.threads.get_thread_by_name(params['server'])
    ip = server.server_model.fetch_ip
    render json: { ip: ip.to_s }
  end

  def destroy
    Server.find(params[:id]).destroy
    Runner::Application.config.threads.delete_threads
    flash[:success] = 'Server deleted'
    redirect_to servers_url
  end

  def cloud_server_destroy
    server = Runner::Application.config.threads.get_thread_by_name(params['server'])
    server.server_model.cloud_server_destroy
    Runner::Application.config.threads.update_models
    render nothing: true
  end

  private

  def set_server_status(server_name, status)
    server = Runner::Application.config.threads.get_thread_by_name(server_name)
    server.server_model.update_attribute(:_status, status)
    Runner::Application.config.threads.update_models
  end

  def update_server_ip(server_name, new_address)
    server = Server.where(name: server_name).first
    server.update_attribute(:address, new_address)
  end

  def server_params
    params.require(:server).permit(:address, :description, :name, :comp_name, :_status, :book_client_id, :last_activity_date, :executing_command_now, :self_destruction)
  end
end
