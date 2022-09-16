# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Runner', type: :request do
  describe 'GET main page' do
    it 'main page returns ok' do
      get(runner_path)
      expect(response).to have_http_status(:ok)
    end
  end
end
