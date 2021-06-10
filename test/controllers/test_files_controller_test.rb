# frozen_string_literal: true

require 'test_helper'

class TestFilesControllerTest < ActionController::TestCase
  before do
    @test_file = test_files(:one)
    @test_list = test_lists(:one)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:test_files)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create test_file' do
    assert_difference('TestFile.count') do
      post :create, params: { test_file: { test_list_id: @test_list.id, name: @test_file.name } }
    end

    assert_redirected_to test_file_path(assigns(:test_file))
  end

  test 'should show test_file' do
    get :show, params: { id: @test_file }
    assert_response :success
  end

  test 'should get edit' do
    get :edit, params: { id: @test_file }
    assert_response :success
  end

  test 'should update test_file' do
    put :update, params: { id: @test_file, test_file: { test_list_id: @test_list.id, name: @test_file.name } }
    assert_redirected_to test_file_path(assigns(:test_file))
  end

  test 'should destroy test_file' do
    assert_difference('TestFile.count', -1) do
      delete :destroy, params: { id: @test_file }
    end

    assert_redirected_to test_files_path
  end
end
