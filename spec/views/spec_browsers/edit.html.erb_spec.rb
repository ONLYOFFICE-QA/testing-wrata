# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'spec_browsers/edit', type: :view do
  before do
    @spec_browser = assign(:spec_browser, SpecBrowser.create!(
                                            name: 'MyString'
                                          ))
  end

  it 'renders the edit spec_browser form' do
    render

    assert_select 'form[action=?][method=?]', spec_browser_path(@spec_browser), 'post' do
      assert_select 'input[name=?]', 'spec_browser[name]'
    end
  end
end
