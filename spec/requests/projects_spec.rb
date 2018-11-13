require 'rails_helper'

RSpec.describe 'Projects', type: :request do
  describe 'GET /projects' do
    it 'works! (now write some real specs)' do
      get projects_path
      expect(response).to have_http_status(302)
    end
  end
end
