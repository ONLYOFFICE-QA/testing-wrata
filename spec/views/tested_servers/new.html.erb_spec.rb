require 'rails_helper'

RSpec.describe 'tested_servers/new', type: :view do
  before(:each) do
    assign(:tested_server, TestedServer.new(
                             url: 'MyString'
    ))
  end

  it 'renders new tested_server form' do
    render

    assert_select 'form[action=?][method=?]', tested_servers_path, 'post' do
      assert_select 'input[name=?]', 'tested_server[url]'
    end
  end
end
