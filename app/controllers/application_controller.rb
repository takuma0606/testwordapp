class ApplicationController < ActionController::Base
  include WordHelper
  before_action:authenticate_user

  def authenticate_user
    if session[:user_id] != nil
      @current_user = User.find(session[:user_id])
    end
  end

  def need_login
    if @current_user == nil
      redirect_to "/"
    end
  end
end
