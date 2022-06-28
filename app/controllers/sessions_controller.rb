# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new
    redirect_to runner_path if current_client&.verified
  end

  def create
    client = Client.find_by(login: params[:session][:login])
    if client&.authenticate(params[:session][:password])
      sign_in_ client
      redirect_to runner_path
    else
      flash[:error] = invalid_login_message
      render 'new'
    end
  end

  def destroy
    sign_out_
    redirect_to runner_path
  end

  private

  # @return [String] message shown if cerdentials invalid
  def invalid_login_message
    'Invalid login/password combination. Or your account still not verified. ' \
      'Contact admin'
  end
end
