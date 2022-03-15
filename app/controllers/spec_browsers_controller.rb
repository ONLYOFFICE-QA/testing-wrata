# frozen_string_literal: true

class SpecBrowsersController < ApplicationController
  before_action :set_spec_browser, only: %i[show edit update destroy]

  # GET /spec_browsers
  # GET /spec_browsers.json
  def index
    @spec_browsers = SpecBrowser.all
  end

  # GET /spec_browsers/1
  # GET /spec_browsers/1.json
  def show; end

  # GET /spec_browsers/new
  def new
    @spec_browser = SpecBrowser.new
  end

  # GET /spec_browsers/1/edit
  def edit; end

  # POST /spec_browsers
  # POST /spec_browsers.json
  def create
    @spec_browser = SpecBrowser.new(spec_browser_params)

    respond_to do |format|
      if @spec_browser.save
        format.html { redirect_to @spec_browser, notice: t(:spec_browser_created_notice) }
        format.json { render :show, status: :created, location: @spec_browser }
      else
        format.html { render :new }
        format.json { render json: @spec_browser.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /spec_browsers/1
  # PATCH/PUT /spec_browsers/1.json
  def update
    respond_to do |format|
      if @spec_browser.update(spec_browser_params)
        format.html { redirect_to @spec_browser, notice: t(:spec_browser_updated_notice) }
        format.json { render :show, status: :ok, location: @spec_browser }
      else
        format.html { render :edit }
        format.json { render json: @spec_browser.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /spec_browsers/1
  # DELETE /spec_browsers/1.json
  def destroy
    @spec_browser.destroy
    respond_to do |format|
      format.html { redirect_to spec_browsers_url, notice: t(:spec_browser_destroyed_notice) }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_spec_browser
    @spec_browser = SpecBrowser.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the allowlist through.
  def spec_browser_params
    params.require(:spec_browser).permit(:name)
  end
end
