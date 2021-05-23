class UserController < ApplicationController
  def login_form
  end

  def login
    @user = User.find_by(name: params[:username], password: params[:password])
    if @user
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
  end

  def new
    @user = User.new(name: params[:username], password: params[:password])
    if @user.save
      session[:user_id] = @user.id
      redirect_to "/"
    else
      render "user/signup"
    end
  end
end
