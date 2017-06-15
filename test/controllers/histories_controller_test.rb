require 'test_helper'

class HistoriesControllerTest < ActionController::TestCase
  setup do
    @history = histories(:one)
    @server = servers(:one)
    @client = clients(:one)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:histories)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create history' do
    assert_difference('History.count') do
      post :create, params: { history: { file: 'test_file', server_id: @server.id, client_id: @client.id } }
    end

    assert_redirected_to history_path(assigns(:history))
  end

  test 'should show history' do
    get :show, params: { id: @history }
    assert_response :success
  end

  test 'should get edit' do
    get :edit, params: { id: @history }
    assert_response :success
  end

  test 'should update history' do
    patch :update, params: { id: @history, history: { file: 'test_file', server_id: @server.id } }
    assert_redirected_to history_path(assigns(:history))
  end

  test 'should destroy history' do
    assert_difference('History.count', -1) do
      delete :destroy, params: { id: @history }
    end

    assert_response :success
  end
end
