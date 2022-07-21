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

  # Render 404 page for incorrect urls
  def render404
    respond_to do |format|
      format.html { render file: Rails.public_path.join('404.html'), layout: false, status: :not_found }
      format.xml  { head :not_found }
      format.any  { head :not_found }
    end
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
