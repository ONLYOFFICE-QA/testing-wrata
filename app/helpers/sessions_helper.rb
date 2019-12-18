# frozen_string_literal: true

module SessionsHelper
  def sign_in_(client)
    cookies.permanent[:remember_token] = client.remember_token
    self.current_client = client
  end

  def signed_in?
    current_client
    !current_client.nil?
  end

  def sign_out_
    self.current_client = nil
    cookies.delete(:remember_token)
  end

  attr_writer :current_client

  def current_client
    @current_client ||= Client.find_by(remember_token: cookies[:remember_token])
  end

  def client_test_lists
    test_lists = []
    client = current_client
    test_lists = client.test_lists.order('created_at DESC') unless client.nil?
    test_lists
  end
end
