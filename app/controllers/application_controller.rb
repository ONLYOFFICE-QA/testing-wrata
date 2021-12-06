# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery

  include SessionsHelper
  # include ServerThreads

  # before_filter :create_threads
  before_action :require_login

  helper_method :wrata_version

  # @return [String] version of product
  def wrata_version
    @wrata_version ||= `git describe`
  rescue StandardError => e
    Rails.logger.warn("Cannot get wrata version with `#{e}` error")
    @wrata_version = 'Unknown'
  end

  protected

  def delete_testlist_by_id(id)
    @test_list = TestList.find(id)
    name = @test_list.name
    if current_client.test_lists.find_by(id: id) == @test_list
      @test_list.test_files.each(&:destroy)
      @test_list.destroy
    end
    Runner::Application.config.delayed_runs&.delete_runs_by_testlist_name(current_client, name)
  end

  private

  def require_login
    return if Rails.env.test?

    if signed_in?
      return redirect_to signin_path unless current_client.actions_allowed?
    else
      redirect_to signin_path
    end
  end
end
