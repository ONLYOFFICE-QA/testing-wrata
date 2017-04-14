require 'rails_helper'

RSpec.describe 'spec_languages/index', type: :view do
  before(:each) do
    assign(:spec_languages, [
             SpecLanguage.create!(
               name: 'Name'
             ),
             SpecLanguage.create!(
               name: 'Name'
             )
           ])
  end

  it 'renders a list of spec_languages' do
    render
    assert_select 'tr>td', text: 'Name'.to_s, count: 2
  end
end
