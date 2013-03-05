#encoding: utf-8
class UserMailer < ActionMailer::Base
  default from: "leap4net@sidways.com"

  #发送用户名和密码
  def forgot_password(user)
    @user = user
    mail(:to => user.email, :subject => "Leap4net,请保存好您的密码")
  end

  def new_user(user)
    @user = user
    mail(:to => user.email, :subject => "Leap4net,请保存好您的密码")
  end

  def order(order, user)
    @order = order
    @user = user
    mail(:to => user.email, :subject => "Leap4net,支付成功")
  end
end
