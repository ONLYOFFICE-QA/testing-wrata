# frozen_string_literal: true

require 'test_helper'

class RunnerControllerTest < ActionController::TestCase
  test 'should get main_page' do
    get :main_page
    assert_response :success
  end
end
