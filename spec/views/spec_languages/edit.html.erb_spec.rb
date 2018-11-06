require 'rails_helper'

RSpec.describe 'spec_languages/edit', type: :view do
  before(:each) do
    @spec_language = assign(:spec_language, SpecLanguage.create!(
                                              name: 'MyString'
                                            ))
  end

  it 'renders the edit spec_language form' do
    render

    assert_select 'form[action=?][method=?]', spec_language_path(@spec_language), 'post' do
      assert_select 'input#spec_language_name[name=?]', 'spec_language[name]'
    end
  end
end
