# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/servers' do
  let(:valid_attributes) do
    { name: 'server-1' }
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      Server.create! valid_attributes
      get servers_url
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      server = Server.create! valid_attributes
      get server_url(server)
      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_server_url
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    it 'renders a successful response' do
      server = Server.create! valid_attributes
      get edit_server_url(server)
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Server' do
        expect do
          post servers_url, params: { server: valid_attributes }
        end.to change(Server, :count).by(1)
      end

      it 'redirects to the created server' do
        post servers_url, params: { server: valid_attributes }
        expect(response).to redirect_to(server_url(Server.last))
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        { name: 'server-2' }
      end

      it 'updates the requested server' do
        server = Server.create! valid_attributes
        patch server_url(server), params: { server: new_attributes }
        server.reload
        expect(server[:name]).to eq(new_attributes[:name])
      end

      it 'redirects to the server' do
        server = Server.create! valid_attributes
        patch server_url(server), params: { server: new_attributes }
        server.reload
        expect(response).to redirect_to(server_url(server))
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested server' do
      server = Server.create! valid_attributes
      expect do
        delete server_url(server)
      end.to change(Server, :count).by(-1)
    end
  end
end
