# frozen_string_literal: true

require 'zip'

class HistoriesController < ApplicationController
  before_action :set_history, only: %i[show edit update destroy log_file]

  # GET /histories
  # GET /histories.json
  def index
    @histories = History.all
  end

  # GET /histories/1
  # GET /histories/1.json
  def show; end

  # GET /histories/new
  def new
    @history = History.new
  end

  # GET /histories/1/edit
  def edit; end

  # POST /histories
  # POST /histories.json
  def create
    @history = History.new(history_params)

    respond_to do |format|
      if @history.save
        format.html { redirect_to @history, notice: 'History was successfully created.' }
        format.json { render action: 'show', status: :created, location: @history }
      else
        format.html { render 'new' }
        format.json { render json: @history.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /histories/1
  # PATCH/PUT /histories/1.json
  def update
    respond_to do |format|
      if @history.update(history_params)
        format.html { redirect_to @history, notice: 'History was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render 'edit' }
        format.json { render json: @history.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /histories/1
  # DELETE /histories/1.json
  def destroy
    @history = History.find(params[:id])
    @history.destroy

    render body: nil
  end

  def show_html_results
    history_line = History.find(params[:history_id])
    @rspec_result = nil
    @file_name = history_line.file
    history_data = history_line.data
    @rspec_result = OnlyofficeRspecResultParser::ResultParser.parse_rspec_html_string(history_data) unless history_data.nil? || history_data == ''

    render layout: false
  end

  def log_file
    send_data @history.log, filename: "wrata-history-#{@history.id}.log"
  end

  def logs
    histories = current_client.histories
    filename = "wrata_logs_archive_#{current_client.login}_#{DateTime.now}.zip"
    temp_file = Tempfile.new(filename)

    begin
      Zip::File.open(temp_file.path, create: true) do |zip|
        histories.each do |history|
          name = "wrata_log_#{history.created_at.in_time_zone}.log"
          log_file = Tempfile.new(name)
          log_file.write(history.to_log_file)
          zip.add(name, log_file.path)
        end
      end

      zip_data = File.read(temp_file.path)
      send_data(zip_data, type: 'application/zip', disposition: 'attachment', filename: filename)
    ensure # important steps below
      temp_file.close
      temp_file.unlink
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_history
    @history = History.find_by(id: params[:id])
  end

  def history_params
    params.require(:history).permit(:log, :file, :server_id, :client_id, :total_result)
  end
end
