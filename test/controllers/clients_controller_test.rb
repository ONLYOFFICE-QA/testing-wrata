require 'test_helper'

class ClientsControllerTest < ActionController::TestCase
  setup do
    @client = clients(:one)
  end

  test 'should get index' do
    get :index
    assert_response :success
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create client' do
    assert_difference('Client.count') do
      post :create, params: { client: { login: 'new_login', password: 'new_pass', password_confirmation: 'new_pass' } }
    end

    assert_redirected_to runner_path
  end

  test 'should show client' do
    get :show, params: { id: @client }
    assert_response :success
  end

  test 'should get edit' do
    get :edit, params: { id: @client }
    assert_response :success
  end

  test 'should update client' do
    put :update, params: { id: @client, client: { login: 'new_login', password: 'new_pass', password_confirmation: 'new_pass' } }
    assert_redirected_to client_path(assigns(:client))
  end

  test 'should destroy client' do
    assert_difference('Client.count', -1) do
      delete :destroy, params: { id: @client }
    end

    assert_redirected_to clients_path
  end
end
