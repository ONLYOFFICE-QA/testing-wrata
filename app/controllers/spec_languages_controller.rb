# frozen_string_literal: true

class SpecLanguagesController < ApplicationController
  before_action :set_spec_language, only: %i[show edit update destroy]

  # GET /spec_languages
  # GET /spec_languages.json
  def index
    @spec_languages = SpecLanguage.all
  end

  # GET /spec_languages/1
  # GET /spec_languages/1.json
  def show; end

  # GET /spec_languages/new
  def new
    @spec_language = SpecLanguage.new
  end

  # GET /spec_languages/1/edit
  def edit; end

  # POST /spec_languages
  # POST /spec_languages.json
  def create
    @spec_language = SpecLanguage.new(spec_language_params)

    respond_to do |format|
      if @spec_language.save
        format.html { redirect_to @spec_language, notice: 'Spec language was successfully created.' }
        format.json { render :show, status: :created, location: @spec_language }
      else
        format.html { render :new }
        format.json { render json: @spec_language.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /spec_languages/1
  # PATCH/PUT /spec_languages/1.json
  def update
    respond_to do |format|
      if @spec_language.update(spec_language_params)
        format.html { redirect_to @spec_language, notice: 'Spec language was successfully updated.' }
        format.json { render :show, status: :ok, location: @spec_language }
      else
        format.html { render :edit }
        format.json { render json: @spec_language.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /spec_languages/1
  # DELETE /spec_languages/1.json
  def destroy
    @spec_language.destroy
    respond_to do |format|
      format.html { redirect_to spec_languages_url, notice: 'Spec language was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_spec_language
    @spec_language = SpecLanguage.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the allowlist through.
  def spec_language_params
    params.require(:spec_language).permit(:name)
  end
end
