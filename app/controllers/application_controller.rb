class ApplicationController < ActionController::Base
  before_action :set_current_user
  helper_method :current_user

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def set_current_user
    @current_user = User.find(session[:user_id]) if session[:user_id]
  end
end
