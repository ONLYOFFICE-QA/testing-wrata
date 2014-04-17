class TestListsController < ApplicationController
  # GET /test_lists
  # GET /test_lists.json

  def index
    @test_lists = TestList.find_all_by_client_id(current_client.id)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @test_lists }
    end
  end

  # DELETE /test_lists/1
  # DELETE /test_lists/1.json
  def destroy
    delete_testlist_by_id(params[:id])

    respond_to do |format|
      format.json { head :no_content }
    end

  end



end
