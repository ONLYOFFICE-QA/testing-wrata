class TestListsController < ApplicationController
  before_action :set_test_list, only: [:show, :edit, :update, :destroy]

  # GET /test_lists
  # GET /test_lists.json
  def index
    @test_lists = TestList.where(:client_id => current_client.id).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @test_lists }
    end
  end

  # GET /test_lists/1
  # GET /test_lists/1.json
  def show
  end

  # GET /test_lists/new
  def new
    @test_list = TestList.new
  end

  # GET /test_lists/1/edit
  def edit
  end

  # POST /test_lists
  # POST /test_lists.json
  def create
    @test_list = TestList.new(test_list_params)

    respond_to do |format|
      if @test_list.save
        format.html { redirect_to @test_list, notice: 'Test list was successfully created.' }
        format.json { render action: 'show', status: :created, location: @test_list }
      else
        format.html { render action: 'new' }
        format.json { render json: @test_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /test_lists/1
  # PATCH/PUT /test_lists/1.json
  def update
    respond_to do |format|
      if @test_list.update(test_list_params)
        format.html { redirect_to @test_list, notice: 'Test list was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @test_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /test_lists/1
  # DELETE /test_lists/1.json
  def destroy
    delete_testlist_by_id(params[:id])

    respond_to do |format|
      format.html { redirect_to test_lists_url}
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_test_list
      @test_list = TestList.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def test_list_params
      params[:test_list]
    end
end
