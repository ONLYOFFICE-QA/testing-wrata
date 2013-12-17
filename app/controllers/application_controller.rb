class ApplicationController < ActionController::Base
  protect_from_forgery

  include SessionsHelper
  #include ServerThreads

  #before_filter :create_threads

  # Force signout to prevent CSRF attacks
  def handle_unverified_request
    sign_out_
    super
  end

  protected

  def delete_testlist_by_id(id)
    @test_list = TestList.find(id)
    if current_client.test_lists.find(id) ==  @test_list
      @test_list.test_files.each do |test_file|
        test_file.strokes.each do |stroke|
          stroke.destroy
        end
        test_file.destroy
      end
      @test_list.destroy
    end
  end

  #protected
  #
  #def create_threads
  #  init_threads
  #end

end
