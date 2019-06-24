class SessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new
    redirect_to runner_path if current_client&.verified
  end

  def create
    client = Client.find_by_login(params[:session][:login])
    if client&.authenticate(params[:session][:password])
      sign_in_ client
      redirect_to runner_path
    else
      flash[:error] = 'Invalid login/password combination. Or your account still not verified. Contact admin' # Not quite right!
      render 'new'
    end
  end

  def destroy
    sign_out_
    redirect_to runner_path
  end
end
