#encoding: utf-8
class ApplicationController < ActionController::Base
  before_filter :set_locale
 
  protect_from_forgery

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def current_user
    @user = User.find(session[:user_id]) if session[:user_id]
  end

  def authenticate_user
    unless current_user
      error_stickie "无权访问！"
      redirect_to login_path
    end
  end

  helper_method :current_user
end
