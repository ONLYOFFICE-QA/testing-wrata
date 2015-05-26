require 'test_helper'

class ClientsControllerTest < ActionController::TestCase
  setup do
    @client = clients(:one)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:client)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create client' do
    assert_difference('Client.count') do
      post :create, client: { login: 'new_login', password: 'new_pass', password_confirmation: 'new_pass'}, security_password: SECURITY_PASSWORD
    end

    assert_redirected_to runner_path
  end

  test 'should show client' do
    get :show, id: @client
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @client
    assert_response :success
  end

  test 'should update client' do
    put :update, id: @client, client: { first_name: @client.first_name, login: @client.login, password: @client.password, post: @client.post, second_name: @client.second_name }
    assert_redirected_to client_path(assigns(:client))
  end

  test 'should destroy client' do
    assert_difference('Client.count', -1) do
      delete :destroy, id: @client
    end

    assert_redirected_to clients_path
  end
end
