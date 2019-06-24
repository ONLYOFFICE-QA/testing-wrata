# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SpecBrowsersController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/spec_browsers').to route_to('spec_browsers#index')
    end

    it 'routes to #new' do
      expect(get: '/spec_browsers/new').to route_to('spec_browsers#new')
    end

    it 'routes to #show' do
      expect(get: '/spec_browsers/1').to route_to('spec_browsers#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/spec_browsers/1/edit').to route_to('spec_browsers#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/spec_browsers').to route_to('spec_browsers#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/spec_browsers/1').to route_to('spec_browsers#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/spec_browsers/1').to route_to('spec_browsers#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/spec_browsers/1').to route_to('spec_browsers#destroy', id: '1')
    end
  end
end
