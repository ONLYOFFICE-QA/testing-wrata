# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'projects/new', type: :view do
  before do
    assign(:project, Project.new(
                       name: 'MyString'
                     ))
  end

  it 'renders new project form' do
    render

    assert_select 'form[action=?][method=?]', projects_path, 'post' do
      assert_select 'input[name=?]', 'project[name]'
    end
  end
end
