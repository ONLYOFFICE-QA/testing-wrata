# frozen_string_literal: true

require 'zip'

class HistoriesController < ApplicationController
  # @return [Integer] max histories in single archive
  MAX_HISTORIES_IN_ARCHIVE = 500
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
        format.html { redirect_to @history, notice: t(:history_created_notice) }
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
        format.html { redirect_to @history, notice: t(:history_updated_notice) }
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

  def user_logs_archive
    filename = "wrata_logs_archive_#{current_client.login}_#{DateTime.now}.zip"
    temp_file = Tempfile.new(filename)

    begin
      form_log_archive(current_client.histories.last(MAX_HISTORIES_IN_ARCHIVE), temp_file)
      send_data(File.read(temp_file.path), type: 'application/zip', disposition: 'attachment', filename: filename)
    rescue StandardError => e
      Rails.logger.error("Something error happened while forming logs #{e}")
      temp_file.close
      temp_file.unlink
      render plain: "Could not create log archive with error: #{e}"
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

  # Method used to form archive file
  # @param [Array<ActiveRecord>] histories list
  # @param [Tempfile] file file to write archive
  # @return [nil]
  def form_log_archive(histories, file)
    Zip::File.open(file.path, create: true) do |zip|
      histories.each do |history|
        name = history.log_filename
        zip.get_output_stream(name) do |f|
          f.write(history.to_log_file)
        end
        zip.commit
      end
    end
  end
end
