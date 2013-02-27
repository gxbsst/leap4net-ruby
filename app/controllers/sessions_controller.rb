class SessionsController < ApplicationController

  #guest 和付费用户登录
  def new

  end

  def create
    if params[:invitation_code] #guest
      user = User.find_by_invitation_code(params[:invitation_code])
    else
      user = User.find_by_email(params[:user][:email])
    end
    if user && user.authenticate(params[:user][:password])
      session[:user_id] = user.id
      redirect_to root_url,  :notice => "登录成功。"
    else
      flash.now.alert = "无效的邮箱或验证码"
      render "new"
    end
  end
end