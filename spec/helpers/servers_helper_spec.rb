# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ServersHelper do
  describe 'test_fail?' do
    it 'test_fail? is falsey for string without failures' do
      expect(helper).not_to be_test_fail(' 0 failures')
    end

    it 'test_fail? is truthy for string with failures' do
      expect(helper).to be_test_fail('1 failures')
    end
  end

  describe 'test_result' do
    it 'test_result is success for no failures' do
      expect(helper.test_result(' 0 failures')).to eq('success')
    end

    it 'test_result is danger for some failures' do
      expect(helper.test_result(' 1 failures')).to eq('danger')
    end
  end
end
