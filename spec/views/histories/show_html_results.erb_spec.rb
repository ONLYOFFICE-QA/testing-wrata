# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'histories/show_html_results', type: :view do
  before do
    @rspec_result = OnlyofficeRspecResultParser::ResultParser.parse_rspec_html('spec/views/histories/html_result.html')
  end

  it 'Show do not have file message if @rspec_result is empty' do
    @rspec_result = nil
    render

    expect(rendered).to match(/Don't have html file of this test!/)
  end

  it 'Contains percentage of completed test' do
    render

    expect(rendered).to match(/100.0%/)
  end

  it 'Contains at least single describe-child' do
    render

    expect(rendered).to match(/describe-child/)
  end

  it 'Contains at least single example-name' do
    render

    expect(rendered).to match(/pipa/)
  end
end
