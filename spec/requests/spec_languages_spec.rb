# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'SpecLanguages', type: :request do
  describe 'GET /spec_languages' do
    it 'works! (now write some real specs)' do
      get spec_languages_path
      expect(response).to have_http_status(200)
    end
  end
end
