require 'rails_helper'

RSpec.describe 'tested_servers/edit', type: :view do
  before(:each) do
    @tested_server = assign(:tested_server, TestedServer.create!(
                                              url: 'MyString'
    ))
  end

  it 'renders the edit tested_server form' do
    render

    assert_select 'form[action=?][method=?]', tested_server_path(@tested_server), 'post' do
      assert_select 'input[name=?]', 'tested_server[url]'
    end
  end
end
