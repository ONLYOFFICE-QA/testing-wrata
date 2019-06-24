# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'spec_browsers/index', type: :view do
  before(:each) do
    assign(:spec_browsers, [
             SpecBrowser.create!(
               name: 'Name1'
             ),
             SpecBrowser.create!(
               name: 'Name2'
             )
           ])
  end

  it 'renders a list of spec_browsers' do
    render
    assert_select 'tr>td', text: /Name./, count: 2
  end
end
