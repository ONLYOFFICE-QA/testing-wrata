# frozen_string_literal: true

require 'test_helper'

class RunnerControllerTest < ActionController::TestCase
  test 'should get index' do
    get :index
    assert_response :success
  end
end
