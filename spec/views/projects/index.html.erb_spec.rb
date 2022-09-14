# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'projects/index', type: :view do
  before do
    assign(:projects, [
             Project.create!(
               name: 'Name1'
             ),
             Project.create!(
               name: 'Name2'
             )
           ])
  end

  it 'renders a list of projects' do
    render
    assert_select 'tr>td', text: /Name./, count: 2
  end
end
