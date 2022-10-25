# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'spec_languages/index' do
  before do
    assign(:spec_languages, [
             SpecLanguage.create!(
               name: 'en-US'
             ),
             SpecLanguage.create!(
               name: 'en-GB'
             )
           ])
  end

  it 'renders a list of spec_languages' do
    render
    assert_select 'tr>td', text: /en.*/, count: 2
  end

  it 'renders a list in order' do
    render
    assert_select 'tr[1]>td', text: 'en-GB', count: 1
    assert_select 'tr[2]>td', text: 'en-US', count: 1
  end
end
