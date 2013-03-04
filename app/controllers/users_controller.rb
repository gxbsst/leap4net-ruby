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
      notice_stickie t("message.modify_password_success")
      redirect_to user_path(@user)
    else
      error_stickie t("message.modify_password_failed")
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
      error_stickie t("message.current_password_error")
      render :change_password
    end
  end

  def check_params
    if params[:old_password].blank? || params[:password].blank? ||params[:password_confirmation].blank?
      warning_stickie t("message.be_empty")
      render :change_password
    elsif params[:password] != params[:password_confirmation]
      warning_stickie t('message.not_the_same_password')
      render :change_password
    end
  end
end