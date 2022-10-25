# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SpecLanguage do
  before do
    @spec_lang = described_class.create!(name: 'en-US')
  end

  it 'When there are already a same spec lang' do
    duplicate = @spec_lang.dup
    expect(duplicate).not_to be_valid
  end
end
