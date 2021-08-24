class UserController < ApplicationController
  def login_form
    @user = User.new
  end

  def login
    @user = User.find_by(name: user_login_params[:name])
    if @user && @user.authenticate(user_login_params[:password])
      session[:user_id] = @user.id
      redirect_to "/"
    else
      render "user/login_form"
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to "/"
  end

  def signup
    @user = User.new
  end

  def new
    @user = User.new(user_signup_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to "/"
    else
      render "user/signup"
    end
  end

  private
  def user_signup_params
    params.require(:user).permit(:name,:password,:password_confirmation)
  end
  def user_login_params
    params.require(:user).permit(:name,:password)
  end
end
