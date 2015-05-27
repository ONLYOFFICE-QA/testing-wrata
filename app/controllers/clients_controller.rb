class ClientsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  # GET /test_files
  # GET /test_files.json
  def index
    @clients = Client.all
  end

  # GET /clients/1
  # GET /clients/1.json
  def show
    @client = Client.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @client }
    end
  end

  # GET /clients/new
  # GET /clients/new.json
  def new
    @client = Client.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @client }
    end
  end

  # GET /clients/1/edit
  def edit
    @client = Client.find(params[:id])
    redirect_to runner_path unless current_client == @client
  end

  # POST /clients
  # POST /clients.json
  def create
    @client = Client.new(params[:client])

    if params['security_password'] == SECURITY_PASSWORD
      if @client.save
        sign_in_ @client
        flash[:success] = 'Welcome to the BEST RUNNER IN THE WORLD!'
        redirect_to runner_path
      else
        render 'new'
      end
    else
      flash[:error] = 'WRONG SECURITY PASSWORD! TRY CALL TO g U M K A -LLI II U H r O JI E T!'
      render 'new'
    end
  end

  def destroy
    Client.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to clients_url
  end

  # PUT /clients/1
  # PUT /clients/1.json
  def update
    @client = Client.find(params[:id])

    return unless current_client == @client
    respond_to do |format|
      if @client.update_attributes(params[:client])
        format.html { redirect_to @client, notice: 'Client was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  def client_history
    client = Client.find_by_id(params[:id])
    @name = client.login
    @history = client.histories.order('created_at DESC').limit(10)
    @controller = :client

    render 'servers/server_history'
  end

  def clear_history
    client = Client.find_by_login(params[:client])
    history = client.histories
    history.delete_all

    render nothing: true
  end

  def show_more
    name = params['name']
    showed = params['showed']

    client = Client.find_by_login(name)
    @history = client.histories.order('created_at DESC').limit(10).offset(showed.to_i)
    @controller = :client

    render '/servers/show_more', layout: false
  end
end
