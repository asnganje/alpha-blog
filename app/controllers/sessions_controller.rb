class SessionsController < ApplicationController
  def new
    @user=User.new
  end

  def create
    user = User.find_by(email:params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      flash[:notice]="Logged in successfully!"
      redirect_to user
    else
      flash.now[:alert]="Incorrect login credentials"
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "Successfully logged out!"
    redirect_to root_path
  end
end