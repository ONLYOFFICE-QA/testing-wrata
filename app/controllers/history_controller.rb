class HistoryController < ApplicationController

  # DELETE /history/1
  def destroy
    @history = History.find(params[:id])
    @history.destroy

    render :nothing => true
  end

  def set_analysed
    @history = History.find(params['id'])
    @history.analysed = true
    @history.save
    render :nothing => true
  end

  def show_html_results
    history_line = History.find(params[:history_id])
    @rspec_result = nil
    @file_name = history_line.file
    history_data = history_line.data
    unless history_data.nil? || history_data == ''
      @rspec_result = ResultParser.parse_rspec_html_string(history_data)
    end

    render :layout => false
  end

end