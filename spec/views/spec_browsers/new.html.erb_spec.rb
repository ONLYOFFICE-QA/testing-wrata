# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'spec_browsers/new' do
  before do
    assign(:spec_browser, SpecBrowser.new(
                            name: 'MyString'
                          ))
  end

  it 'renders new spec_browser form' do
    render

    assert_select 'form[action=?][method=?]', spec_browsers_path, 'post' do
      assert_select 'input[name=?]', 'spec_browser[name]'
    end
  end
end
