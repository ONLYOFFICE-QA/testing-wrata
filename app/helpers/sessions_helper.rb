module SessionsHelper

  def sign_in_(client)  #_fix for active-admin
    cookies.permanent[:remember_token] = client.remember_token
    self.current_client = client
  end

  def signed_in?
    current_client
    !current_client.nil?
  end

  def sign_out_ #_fix for active-admin
    self.current_client = nil
    cookies.delete(:remember_token)
  end

  def current_client=(client)
    @current_client = client
  end

  def current_client
    @current_client ||= Client.find_by_remember_token(cookies[:remember_token])
  end

  def get_client_test_lists
    test_lists = []
    client = current_client
    unless client.nil?
      test_lists = client.test_lists.order('created_at DESC')
    end
    test_lists
  end

end
