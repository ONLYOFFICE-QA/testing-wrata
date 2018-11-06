require 'rails_helper'

RSpec.describe 'spec_languages/new', type: :view do
  before(:each) do
    assign(:spec_language, SpecLanguage.new(
                             name: 'MyString'
                           ))
  end

  it 'renders new spec_language form' do
    render

    assert_select 'form[action=?][method=?]', spec_languages_path, 'post' do
      assert_select 'input#spec_language_name[name=?]', 'spec_language[name]'
    end
  end
end
