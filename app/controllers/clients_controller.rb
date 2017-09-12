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
  end

  # POST /clients
  # POST /clients.json
  def create
    @client = Client.new(client_params)

    if @client.save
      sign_in_ @client
      flash[:success] = 'Your account successfully created. Please wait for verification by admin'
      redirect_to runner_path
    else
      render 'new'
    end
  end

  def destroy
    Client.find(params[:id]).destroy
    flash[:success] = 'User deleted'
    redirect_to clients_url
  end

  # PUT /clients/1
  # PUT /clients/1.json
  def update
    @client = Client.find(params[:id])

    respond_to do |format|
      if @client.update_attributes(client_params)
        format.html { redirect_to @client, notice: 'Client was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render 'edit' }
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

    render body: nil
  end

  def show_more
    name = params['name']
    showed = params['showed']

    client = Client.find_by_login(name)
    @history = client.histories.order('created_at DESC').limit(10).offset(showed.to_i)
    @controller = :client

    return render body: nil if @history.empty?
    render '/servers/show_more', layout: false
  end

  private

  def client_params
    params.require(:client).permit(:login,
                                   :password,
                                   :password_confirmation,
                                   :post,
                                   :first_name,
                                   :second_name,
                                   :verified,
                                   :project)
  end
end
