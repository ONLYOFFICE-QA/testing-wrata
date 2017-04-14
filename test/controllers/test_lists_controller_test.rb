require 'test_helper'

class TestListsControllerTest < ActionController::TestCase
  setup do
    @test_list = test_lists(:one)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:test_lists)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create test_list' do
    assert_difference('TestList.count') do
      post :create, params: { test_list: { client_id: @test_list.client_id, name: @test_list.name } }
    end

    assert_redirected_to test_list_path(assigns(:test_list))
  end

  test 'should show test_list' do
    get :show, params: { id: @test_list }
    assert_response :success
  end

  test 'should get edit' do
    get :edit, params: { id: @test_list }
    assert_response :success
  end

  test 'should update test_list' do
    put :update, params: { id: @test_list, test_list: { client_id: @test_list.client_id, name: @test_list.name } }
    assert_redirected_to test_list_path(assigns(:test_list))
  end

  test 'should destroy test_list' do
    skip('Not working for some reason in CircleCi') # TODO: Fix it
    assert_difference('TestList.count', -1) do
      delete :destroy, params: { id: @test_list }
    end

    assert_response :success
  end
end
