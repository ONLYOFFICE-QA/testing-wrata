require 'rails_helper'

RSpec.describe RunnerController, type: :controller do
  describe 'GET #file_tree' do
    it 'require file tree without parameter' do
      get :file_tree, params: {}
      expect(response.status).to eq(400)
    end

    it 'require file tree with project and branch' do
      get :file_tree, params: { project: 'ONLYOFFICE/ooxml_parser', refs: 'master' }
      parsed_json = JSON.parse(response.body)
      expect(parsed_json).to have_key('children')
    end
  end
end
