# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'projects/show', type: :view do
  before(:each) do
    @project = assign(:project, Project.create!(
                                  name: 'Name'
                                ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Name/)
  end
end
