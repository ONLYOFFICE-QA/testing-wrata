module SessionsHelper
  def sign_in_(client)
    cookies.permanent[:remember_token] = client.remember_token
    self.current_client = client
    init_run_manager
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
    @current_client ||= Client.find_by_remember_token(cookies[:remember_token])
  end

  def client_test_lists
    test_lists = []
    client = current_client
    test_lists = client.test_lists.order('created_at DESC') unless client.nil?
    test_lists
  end

  def get_run_manager(client_login)
    Runner::Application.config.run_manager = RunnerManagers.new if Runner::Application.config.run_manager.nil?
    Runner::Application.config.run_manager.find_manager_by_client_login(client_login)
  end

  def init_run_manager
    @client = current_client
    return if get_run_manager @client.login
    Runner::Application.config.run_manager.add_manager ClientRunnerManager.new(@client)
  end
end
