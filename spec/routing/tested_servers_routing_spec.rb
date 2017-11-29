require 'rails_helper'

RSpec.describe TestedServersController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/tested_servers').to route_to('tested_servers#index')
    end

    it 'routes to #new' do
      expect(get: '/tested_servers/new').to route_to('tested_servers#new')
    end

    it 'routes to #show' do
      expect(get: '/tested_servers/1').to route_to('tested_servers#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/tested_servers/1/edit').to route_to('tested_servers#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/tested_servers').to route_to('tested_servers#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/tested_servers/1').to route_to('tested_servers#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/tested_servers/1').to route_to('tested_servers#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/tested_servers/1').to route_to('tested_servers#destroy', id: '1')
    end
  end
end
