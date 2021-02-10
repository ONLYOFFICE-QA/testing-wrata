# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'histories/show_html_results', type: :view do
  it 'Show do not have file message if @rspec_result is empty' do
    render

    expect(rendered).to match(/Don't have html file of this test!/)
  end
end
