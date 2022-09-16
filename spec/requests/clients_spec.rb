# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Clients', type: :request do
  new_client_data = { client: { login: 'new_login',
                                password: 'new_pass',
                                password_confirmation: 'new_pass' } }
  it 'GET new' do
    get(new_client_path)
    expect(response).to render_template(:new)
  end

  it 'GET index' do
    get(clients_path)
    expect(response).to render_template(:index)
  end

  it 'Creating a client' do
    expect do
      post(clients_path,
           params: new_client_data)
    end.to change(Client, :count).by(1)

    expect(response).to redirect_to(runner_path)
  end

  it 'Show a client' do
    get("#{clients_path}/1")
    expect(response).to render_template('clients/show')
  end

  it 'Get an edit page' do
    get(edit_client_path(1))
    expect(response).to render_template('clients/edit')
  end

  it 'Post an update to client' do
    put("#{clients_path}/1",
        params: { id: 1 }.merge(new_client_data))
    expect(response).to redirect_to(client_path(1))
  end

  it 'Destroy a client' do
    expect do
      delete("#{clients_path}/1",
             params: { id: 1 })
    end.to change(Client, :count).by(-1)

    expect(response).to redirect_to(clients_path)
  end
end
