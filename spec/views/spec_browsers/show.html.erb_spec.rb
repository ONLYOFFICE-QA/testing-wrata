# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'spec_browsers/show', type: :view do
  before(:each) do
    @spec_browser = assign(:spec_browser, SpecBrowser.create!(
                                            name: 'Name'
                                          ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Name/)
  end
end
