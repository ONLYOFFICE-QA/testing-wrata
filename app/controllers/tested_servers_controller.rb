class TestedServersController < ApplicationController
  before_action :set_tested_server, only: %i[show edit update destroy]

  # GET /tested_servers
  # GET /tested_servers.json
  def index
    @tested_servers = TestedServer.all
  end

  # GET /tested_servers/1
  # GET /tested_servers/1.json
  def show; end

  # GET /tested_servers/new
  def new
    @tested_server = TestedServer.new
  end

  # GET /tested_servers/1/edit
  def edit; end

  # POST /tested_servers
  # POST /tested_servers.json
  def create
    @tested_server = TestedServer.new(tested_server_params)

    respond_to do |format|
      if @tested_server.save
        format.html { redirect_to @tested_server, notice: 'Tested server was successfully created.' }
        format.json { render :show, status: :created, location: @tested_server }
      else
        format.html { render :new }
        format.json { render json: @tested_server.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tested_servers/1
  # PATCH/PUT /tested_servers/1.json
  def update
    respond_to do |format|
      if @tested_server.update(tested_server_params)
        format.html { redirect_to @tested_server, notice: 'Tested server was successfully updated.' }
        format.json { render :show, status: :ok, location: @tested_server }
      else
        format.html { render :edit }
        format.json { render json: @tested_server.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tested_servers/1
  # DELETE /tested_servers/1.json
  def destroy
    @tested_server.destroy
    respond_to do |format|
      format.html { redirect_to tested_servers_url, notice: 'Tested server was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_tested_server
    @tested_server = TestedServer.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def tested_server_params
    params.require(:tested_server).permit(:url)
  end
end
