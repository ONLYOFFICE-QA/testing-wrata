# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TestFilesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/test_files').to route_to('test_files#index')
    end

    it 'routes to #new' do
      expect(get: '/test_files/new').to route_to('test_files#new')
    end

    it 'routes to #show' do
      expect(get: '/test_files/1').to route_to('test_files#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/test_files/1/edit').to route_to('test_files#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/test_files').to route_to('test_files#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/test_files/1').to route_to('test_files#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/test_files/1').to route_to('test_files#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/test_files/1').to route_to('test_files#destroy', id: '1')
    end
  end
end
