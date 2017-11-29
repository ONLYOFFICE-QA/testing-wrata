require 'rails_helper'

RSpec.describe 'tested_servers/index', type: :view do
  before(:each) do
    assign(:tested_servers, [
             TestedServer.create!(
               url: 'Url'
             ),
             TestedServer.create!(
               url: 'Url'
             )
           ])
  end

  it 'renders a list of tested_servers' do
    render
    assert_select 'tr>td', text: 'Url'.to_s, count: 2
  end
end
