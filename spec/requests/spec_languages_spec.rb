# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/spec_languages' do
  let(:valid_attributes) do
    { name: 'en-US' }
  end

  let(:invalid_attributes) do
    { name: '1' }
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      SpecLanguage.create! valid_attributes
      get spec_languages_url
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      spec_language = SpecLanguage.create! valid_attributes
      get spec_language_url(spec_language)
      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_spec_language_url
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    it 'renders a successful response' do
      spec_language = SpecLanguage.create! valid_attributes
      get edit_spec_language_url(spec_language)
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new SpecLanguage' do
        expect do
          post spec_languages_url, params: { spec_language: valid_attributes }
        end.to change(SpecLanguage, :count).by(1)
      end

      it 'redirects to the created spec_language' do
        post spec_languages_url, params: { spec_language: valid_attributes }
        expect(response).to redirect_to(spec_language_url(SpecLanguage.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new SpecLanguage' do
        expect do
          post spec_languages_url, params: { spec_language: invalid_attributes }
        end.not_to change(SpecLanguage, :count)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post spec_languages_url, params: { spec_language: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        { name: 'en-GB' }
      end

      it 'updates the requested spec_language' do
        spec_language = SpecLanguage.create! valid_attributes
        patch spec_language_url(spec_language), params: { spec_language: new_attributes }
        spec_language.reload
        expect(spec_language[:name]).to eq(new_attributes[:name])
      end

      it 'redirects to the spec_language' do
        spec_language = SpecLanguage.create! valid_attributes
        patch spec_language_url(spec_language), params: { spec_language: new_attributes }
        spec_language.reload
        expect(response).to redirect_to(spec_language_url(spec_language))
      end
    end

    context 'with invalid parameters' do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        spec_language = SpecLanguage.create! valid_attributes
        patch spec_language_url(spec_language), params: { spec_language: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested spec_language' do
      spec_language = SpecLanguage.create! valid_attributes
      expect do
        delete spec_language_url(spec_language)
      end.to change(SpecLanguage, :count).by(-1)
    end

    it 'redirects to the spec_languages list' do
      spec_language = SpecLanguage.create! valid_attributes
      delete spec_language_url(spec_language)
      expect(response).to redirect_to(spec_languages_url)
    end
  end
end
