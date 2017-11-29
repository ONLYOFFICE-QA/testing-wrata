require 'rails_helper'

RSpec.describe 'tested_servers/show', type: :view do
  before(:each) do
    @tested_server = assign(:tested_server, TestedServer.create!(
                                              url: 'Url'
    ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Url/)
  end
end
