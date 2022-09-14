# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SpecBrowser, type: :model do
  it 'is valid with some name' do
    expect(described_class.new(name: 'chrome')).to be_valid
  end

  it 'is not valid with default attributes' do
    expect(described_class.new).not_to be_valid
  end

  it 'is not valid if any numbers in name' do
    expect(described_class.new(name: '1')).not_to be_valid
  end

  it 'is not valid if any special symbols in name' do
    expect(described_class.new(name: '-$')).not_to be_valid
  end
end
