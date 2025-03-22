class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :require_user, except: [:show, :index, :new, :create]
  before_action :require_same_user, only: [:edit, :update, :destroy]

  def new
    @user = User.new
  end

  def index
    @users=User.all
  end

  def show
    # @articles=@user.articles
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "Welcome to the Alpha Blog #{@user.username}, you have successfully signed up!"
      redirect_to articles_path
    else
      render 'new'
    end
  end

  def update 
    if @user.update(user_params)
      flash[:notice]= "#{@user.username}'s details successfully updated"
      redirect_to user_path
    else
      render 'edit'
    end
  end
  def destroy
    @user.destroy
    if helpers.current_user != @user
      flash[:notice] = "Account and all associated articles successfully deleted"
      redirect_to users_path
    else
      flash[:notice] = "Account and all associated articles successfully deleted"
      session[:user_id] = nil
      redirect_to root_path
    end
  end

  private
  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def require_same_user
    if @user != helpers.current_user && !helpers.current_user.admin?
      flash[:alert] = "You are not allowed to perform that action!"
      redirect_to @user
    end
  end
end