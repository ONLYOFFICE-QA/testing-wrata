# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SpecLanguage, type: :model do
  before do
    @spec_lang = described_class.create!(name: 'Lang1')
  end

  it 'When there are already a same spec lang' do
    duplicate = @spec_lang.dup
    expect(duplicate).not_to be_valid
  end
end
