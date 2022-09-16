# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TestListsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/test_lists').to route_to('test_lists#index')
    end

    it 'routes to #new' do
      expect(get: '/test_lists/new').to route_to('test_lists#new')
    end

    it 'routes to #show' do
      expect(get: '/test_lists/1').to route_to('test_lists#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/test_lists/1/edit').to route_to('test_lists#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/test_lists').to route_to('test_lists#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/test_lists/1').to route_to('test_lists#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/test_lists/1').to route_to('test_lists#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/test_lists/1').to route_to('test_lists#destroy', id: '1')
    end
  end
end
