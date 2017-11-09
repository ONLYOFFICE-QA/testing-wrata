require 'rails_helper'

RSpec.describe SpecLanguage, type: :model do
  before do
    @spec_lang = SpecLanguage.create!(name: 'Lang1')
  end

  it 'When there are already a same spec lang' do
    duplicate = @spec_lang.dup
    expect(duplicate).not_to be_valid
  end
end
