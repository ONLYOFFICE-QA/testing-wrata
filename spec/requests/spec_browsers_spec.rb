# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/spec_browsers' do
  let(:valid_attributes) do
    { name: 'chrome' }
  end

  let(:invalid_attributes) do
    { name: 'Another Chrome' }
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      SpecBrowser.create! valid_attributes
      get spec_browsers_url
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      spec_browser = SpecBrowser.create! valid_attributes
      get spec_browser_url(spec_browser)
      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_spec_browser_url
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    it 'renders a successful response' do
      spec_browser = SpecBrowser.create! valid_attributes
      get edit_spec_browser_url(spec_browser)
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new SpecBrowser' do
        expect do
          post spec_browsers_url, params: { spec_browser: valid_attributes }
        end.to change(SpecBrowser, :count).by(1)
      end

      it 'redirects to the created spec_browser' do
        post spec_browsers_url, params: { spec_browser: valid_attributes }
        expect(response).to redirect_to(spec_browser_url(SpecBrowser.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new SpecBrowser' do
        expect do
          post spec_browsers_url, params: { spec_browser: invalid_attributes }
        end.not_to change(SpecBrowser, :count)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post spec_browsers_url, params: { spec_browser: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        { name: 'firefox' }
      end

      it 'updates the requested spec_browser' do
        spec_browser = SpecBrowser.create! valid_attributes
        patch spec_browser_url(spec_browser), params: { spec_browser: new_attributes }
        spec_browser.reload
        expect(spec_browser[:name]).to eq(new_attributes[:name])
      end

      it 'redirects to the spec_browser' do
        spec_browser = SpecBrowser.create! valid_attributes
        patch spec_browser_url(spec_browser), params: { spec_browser: new_attributes }
        spec_browser.reload
        expect(response).to redirect_to(spec_browser_url(spec_browser))
      end
    end

    context 'with invalid parameters' do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        spec_browser = SpecBrowser.create! valid_attributes
        patch spec_browser_url(spec_browser), params: { spec_browser: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested spec_browser' do
      spec_browser = SpecBrowser.create! valid_attributes
      expect do
        delete spec_browser_url(spec_browser)
      end.to change(SpecBrowser, :count).by(-1)
    end

    it 'redirects to the spec_browsers list' do
      spec_browser = SpecBrowser.create! valid_attributes
      delete spec_browser_url(spec_browser)
      expect(response).to redirect_to(spec_browsers_url)
    end
  end
end
