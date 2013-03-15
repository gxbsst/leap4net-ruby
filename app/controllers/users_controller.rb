#encoding: utf-8
class UsersController < ApplicationController
  before_filter :get_user
  before_filter :check_params, :only => :reset_password
  before_filter :authenticate_password, :only => :reset_password
  before_filter :authenticate_email, :only => :send_password

  def forgot_password
    render :layout => false
  end

  def send_password
    UserMailer.forgot_password(@user).deliver
    notice_stickie t("forgot_password.mailing_success")
    redirect_to login_path
  end

  def show
    @order = @user.orders.first
  end

  def change_password
    
  end

  def reset_password
    @old_passowrd = @user.cleartext_password
    @user.set_password params[:password]
    if @user.save
      # 删除旧密码
      #@user.delete_line_text(@old_passowrd)
      # 生成新密码
      #@user.write_vpn_pass
      UserMailer.forgot_password(@user).deliver
      notice_stickie t("message.modify_password_success")
      redirect_to user_path(@user)
    else
      error_stickie t("message.modify_password_failed")
      render :change_password
    end
  end

  def build_invitation_code
    @invitation_code = Refinery::InvicationCodes::InvicationCode.new(:begin_at => Time.now)
    @invitation_code.user_id = current_user.id
    @invitation_code.end_at = Time.now + 6.months
    @invitation_code.code = User.init_password #实则为生成随机码
    @invitation_code.save
  end

  private

  def authenticate_email
    if params[:user][:email].present?
      @user = User.find_by_email(params[:user][:email])
      unless @user
        error_stickie t('forgot_password.no_user')
        render :forgot_password, :layout => false
      end
    else
      warning_stickie t("forgot_password.write_email")
      render :forgot_password, :layout => false
    end
      
  end

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