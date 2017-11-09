require 'rails_helper'

RSpec.describe 'spec_languages/index', type: :view do
  before(:each) do
    assign(:spec_languages, [
             SpecLanguage.create!(
               name: 'Name1'
             ),
             SpecLanguage.create!(
               name: 'Name2'
             )
           ])
  end

  it 'renders a list of spec_languages' do
    render
    assert_select 'tr>td', text: /Name./, count: 2
  end
end
