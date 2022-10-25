# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/histories' do
  fixtures :all

  let(:valid_attributes) do
    { server_id: servers(:one).id, client_id: clients(:one).id }
  end

  let(:invalid_attributes) do
    { log: 'log' }
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      History.create! valid_attributes
      get histories_url
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      history = History.create! valid_attributes
      get history_url(history)
      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_history_url
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    it 'renders a successful response' do
      history = History.create! valid_attributes
      get edit_history_url(history)
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new History' do
        expect do
          post histories_url, params: { history: valid_attributes }
        end.to change(History, :count).by(1)
      end

      it 'redirects to the created history' do
        post histories_url, params: { history: valid_attributes }
        expect(response).to redirect_to(history_url(History.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new History' do
        expect do
          post histories_url, params: { history: invalid_attributes }
        end.not_to change(History, :count)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post histories_url, params: { history: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        { server_id: servers(:one).id, client_id: clients(:one).id, log: 'log' }
      end

      it 'updates the requested history' do
        history = History.create! valid_attributes
        patch history_url(history), params: { history: new_attributes }
        history.reload
        expect(history[:log]).to eq(new_attributes[:log])
      end

      it 'redirects to the history' do
        history = History.create! valid_attributes
        patch history_url(history), params: { history: new_attributes }
        history.reload
        expect(response).to redirect_to(history_url(history))
      end
    end

    context 'with invalid parameters' do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        history = History.create! valid_attributes
        patch history_url(history), params: { history: invalid_attributes }
        expect(response).not_to be_successful
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested history' do
      history = History.create! valid_attributes
      expect do
        delete history_url(history)
      end.to change(History, :count).by(-1)
    end

    it 'redirects to the histories list' do
      history = History.create! valid_attributes
      delete history_url(history)
      expect(response).to be_successful
    end
  end
end
