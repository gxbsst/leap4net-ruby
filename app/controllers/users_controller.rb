#encoding: utf-8
class UsersController < ApplicationController
  before_filter :get_user
  before_filter :check_params, :only => :reset_password
  before_filter :authenticate_password, :only => :reset_password
  def show
    @order = @user.orders.first
  end

  def change_password
    
  end

  def reset_password
    @user.set_password params[:password]
    if @user.save
      notice_stickie "成功修改密码。"
      redirect_to user_path(@user)
    else
      error_stickie "修改密码失败！"
      render :change_password
    end
  end

  def build_invitation_code
    guest_user = @user.build_guest_user
    @invitation_code = guest_user.invitation_code
  end

  private

  def get_user
    @user = current_user
  end

  def authenticate_password
    unless @user.authenticate(params[:old_password])
      error_stickie "当前密码填写错误！"
      render :change_password
    end
  end

  def check_params
    if params[:old_password].blank? || params[:password].blank? ||params[:password_confirmation].blank?
      warning_stickie "三项都不能为空！"
      render :change_password
    elsif params[:password] != params[:password_confirmation]
      warning_stickie '新密码和确认密码不同！'
      render :change_password
    end
  end
end