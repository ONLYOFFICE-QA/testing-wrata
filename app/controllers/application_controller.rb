class ApplicationController < ActionController::Base
  protect_from_forgery

  include SessionsHelper
  # include ServerThreads

  # before_filter :create_threads
  before_action :require_login

  # Force signout to prevent CSRF attacks
  def handle_unverified_request
    sign_out_
    super
  end

  protected

  def delete_testlist_by_id(id)
    @test_list = TestList.find(id)
    name = @test_list.name
    if current_client.test_lists.find_by_id(id) ==  @test_list
      @test_list.test_files.each do |test_file|
        test_file.strokes.each(&:destroy)
        test_file.destroy
      end
      @test_list.destroy
    end                                           #
    $delayed_runs.delete_runs_by_testlist_name(@client, name)
  end

  private

  def require_login
    if signed_in?
      init_run_manager
    else
      redirect_to signin_path
    end
  end
end
