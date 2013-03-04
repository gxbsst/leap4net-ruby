#encoding: utf-8
class SessionsController < ApplicationController
  layout false
  before_filter :check_invitation_code, :only => :guest_login
  before_filter :check_email_and_password, :only => :create
  #guest 和付费用户登录
  def new
  end
  
  #邀请码登录
  def guest_login
    invitation_code = Refinery::InvicationCodes::InvicationCode.find_by_code(params[:invitation_code])
    if invitation_code && invitation_code.within_deadline?
      session[:user_id] = User.find_by_name('guest').id
      notice_stickie "登录成功。"
      redirect_to root_url
    else
      warning_stickie "无效邀请码或者邀请码已过期！"
      render :new
    end
  end

  #已购买用户登录
  def create
    user = User.find_by_email(params[:user][:email])
    if user && user.authenticate(params[:user][:password])
      session[:user_id] = user.id
      notice_stickie "登录成功。"
      redirect_to root_url
    else
      error_stickie '邮箱或密码错误！'
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    notice_stickie "成功退出登录。"
    redirect_to login_path
  end

  private

  def check_invitation_code
    if params[:invitation_code].blank?
      warning_stickie '请填写邀请码！'
      render :new
    end
  end

  def check_email_and_password
    if params[:user][:email].blank? || params[:user][:password].blank?
      warning_stickie "请填写邮箱或密码！"
      render :new
    end
  end
end