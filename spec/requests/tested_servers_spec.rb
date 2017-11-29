require 'rails_helper'

RSpec.describe 'TestedServers', type: :request do
  describe 'GET /tested_servers' do
    it 'works! (now write some real specs)' do
      get tested_servers_path
      expect(response).to have_http_status(302)
    end
  end
end
