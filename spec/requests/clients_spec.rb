# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/clients' do
  let(:valid_attributes) do
    { login: 'User1', password: '123' }
  end

  let(:invalid_attributes) do
    { login: 'User2' }
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      Client.create! valid_attributes
      get clients_url
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      client = Client.create! valid_attributes
      get client_url(client)
      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_client_url
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    it 'renders a successful response' do
      client = Client.create! valid_attributes
      get edit_client_url(client)
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Client' do
        expect do
          post clients_url, params: { client: valid_attributes }
        end.to change(Client, :count).by(1)
      end

      it 'rediret to root afterr creating' do
        post clients_url, params: { client: valid_attributes }
        expect(response).to redirect_to(runner_path)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Client' do
        expect do
          post clients_url, params: { client: invalid_attributes }
        end.not_to change(Client, :count)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post clients_url, params: { client: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        { login: 'User3', password: '123' }
      end

      it 'updates the requested client' do
        client = Client.create! valid_attributes
        patch client_url(client), params: { client: new_attributes }
        client.reload
        expect(client[:name]).to eq(new_attributes[:name])
      end

      it 'redirects to the client' do
        client = Client.create! valid_attributes
        patch client_url(client), params: { client: new_attributes }
        client.reload
        expect(response).to redirect_to(client_url(client))
      end
    end

    context 'with invalid parameters' do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        client = Client.create! valid_attributes
        patch client_url(client), params: { client: invalid_attributes }
        expect(response).not_to be_successful
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested client' do
      client = Client.create! valid_attributes
      expect do
        delete client_url(client)
      end.to change(Client, :count).by(-1)
    end

    it 'redirects to the clients list' do
      client = Client.create! valid_attributes
      delete client_url(client)
      expect(response).to redirect_to(clients_url)
    end
  end
end
