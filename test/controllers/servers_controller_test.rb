# frozen_string_literal: true

require 'test_helper'

class ServersControllerTest < ActionController::TestCase
  setup do
    @server = servers(:one)
    Runner::Application.config.threads = ServerThreads.new.init_threads
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

  test 'should create server' do
    assert_difference('Server.count') do
      post :create, params: { server: { address: @server.address, description: @server.description, name: @server.name } }
    end

    assert_redirected_to server_path(assigns(:server))
  end

  test 'should show server' do
    get :show, params: { id: @server }
    assert_response :success
  end

  test 'should get edit' do
    get :edit, params: { id: @server }
    assert_response :success
  end

  test 'should update server' do
    put :update, params: { id: @server, server: { address: @server.address, description: @server.description, name: @server.name } }
    assert_redirected_to server_path(assigns(:server))
  end

  test 'should destroy server' do
    assert_difference('Server.count', -1) do
      delete :destroy, params: { id: @server }
    end

    assert_redirected_to servers_path
  end
end
