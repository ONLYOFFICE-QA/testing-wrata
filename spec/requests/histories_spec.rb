# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Histories', type: :request do
  it 'GET /histories/new' do
    get(new_history_path)
    expect(response).to render_template(:new)
  end

  it 'GET /histories' do
    get(histories_path)
    expect(response).to render_template(:index)
  end
end
