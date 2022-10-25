# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'spec_browsers/index' do
  before do
    assign(:spec_browsers, [
             SpecBrowser.create!(
               name: 'chrome'
             ),
             SpecBrowser.create!(
               name: 'chromeanother'
             )
           ])
  end

  it 'renders a list of spec_browsers' do
    render
    assert_select 'tr>td', text: /chrome.*/, count: 2
  end
end
