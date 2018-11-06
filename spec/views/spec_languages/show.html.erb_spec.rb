require 'rails_helper'

RSpec.describe 'spec_languages/show', type: :view do
  before(:each) do
    @spec_language = assign(:spec_language, SpecLanguage.create!(
                                              name: 'Name'
                                            ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Name/)
  end
end
