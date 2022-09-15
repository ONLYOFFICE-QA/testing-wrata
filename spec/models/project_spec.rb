# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Project, type: :model do
  it 'is valid with default attributes' do
    expect(described_class.new).to be_valid
  end

  it 'is not valid with very long name' do
    expect(described_class.new(name: 'a' * 257)).not_to be_valid
  end
end
