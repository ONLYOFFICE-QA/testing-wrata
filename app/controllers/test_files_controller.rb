class TestFilesController < ApplicationController
  before_action :set_test_file, only: [:show, :edit, :update, :destroy]

  # GET /test_files
  # GET /test_files.json
  def index
    @test_files = TestFile.all
  end

  # GET /test_files/1
  # GET /test_files/1.json
  def show
  end

  # GET /test_files/new
  def new
    @test_file = TestFile.new
  end

  # GET /test_files/1/edit
  def edit
  end

  # POST /test_files
  # POST /test_files.json
  def create
    @test_file = TestFile.new(test_file_params)

    respond_to do |format|
      if @test_file.save
        format.html { redirect_to @test_file, notice: 'Test file was successfully created.' }
        format.json { render action: 'show', status: :created, location: @test_file }
      else
        format.html { render action: 'new' }
        format.json { render json: @test_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /test_files/1
  # PATCH/PUT /test_files/1.json
  def update
    respond_to do |format|
      if @test_file.update(test_file_params)
        format.html { redirect_to @test_file, notice: 'Test file was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @test_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /test_files/1
  # DELETE /test_files/1.json
  def destroy
    @test_file.destroy
    respond_to do |format|
      format.html { redirect_to test_files_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_test_file
      @test_file = TestFile.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def test_file_params
      params[:test_file]
    end
end
