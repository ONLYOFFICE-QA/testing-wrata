# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'spec_languages/index', type: :view do
  before do
    assign(:spec_languages, [
             SpecLanguage.create!(
               name: 'Name2'
             ),
             SpecLanguage.create!(
               name: 'Name1'
             )
           ])
  end

  it 'renders a list of spec_languages' do
    render
    assert_select 'tr>td', text: /Name./, count: 2
  end

  it 'renders a list in order' do
    render
    assert_select 'tr[1]>td', text: 'Name1', count: 1
    assert_select 'tr[2]>td', text: 'Name2', count: 1
  end
end
