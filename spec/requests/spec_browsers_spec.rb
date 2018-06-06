require 'rails_helper'

RSpec.describe 'SpecBrowsers', type: :request do
  describe 'GET /spec_browsers' do
    it 'works! (now write some real specs)' do
      get spec_browsers_path
      expect(response).to have_http_status(200)
    end
  end
end
