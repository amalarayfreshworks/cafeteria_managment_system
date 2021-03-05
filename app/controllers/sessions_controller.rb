class SessionsController < ApplicationController
  #before_action :ensure_user_logged_in

  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:current_user_id] = user.id

      if user.role == "admin"
        redirect_to "/admin"
      else
        redirect_to "/menu"
      end
    else
      flash[:error] = "Something went wrong! Try Again"
      redirect_to new_sessions_path
    end
  end

  def destroy
    session[:current_user_id] = nil
    @current_user = nil
    redirect_to "/"
  end
end
