require 'test_helper'

class ServersControllerTest < ActionController::TestCase
  setup do
    @user = server(:one)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:servers)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create user' do
    assert_difference('Server.count') do
      post :create, user: { address: @user.address, description: @user.description, name: @user.name }
    end

    assert_redirected_to user_path(assigns(:user))
  end

  test 'should show user' do
    get :show, id: @user
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @user
    assert_response :success
  end

  test 'should update user' do
    put :update, id: @user, user: { address: @user.address, description: @user.description, name: @user.name }
    assert_redirected_to user_path(assigns(:user))
  end

  test 'should destroy user' do
    assert_difference('Server.count', -1) do
      delete :destroy, id: @user
    end

    assert_redirected_to users_path
  end
end
