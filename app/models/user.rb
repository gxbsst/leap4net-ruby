#encoding: utf-8
class User < ActiveRecord::Base
  # user_type Guest、 Commom、Disabled
  #guest 默认密码为"leap4_net"
  attr_accessible :name, :user_type, :email, :password_confirmation, :password, :builder_id
  has_secure_password
  validates :password, :presence => true, :on => :create
  validates :user_type, :presence => true
  before_validation :init_password
  after_save :rewrite_password

  has_many :orders

  def set_password(password)
    self.password = password
    self.password_confirmation = password
    self.cleartext_password = password
  end

  #生成50位包含大小写得随机字符串。
  def init_invitation_code
    o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
    (0...50).map { o[rand(o.length)] }.join
  end

  #同时生成邀请码
  def self.init_password
    o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
    (0...6).map { o[rand(o.length)] }.join
  end

  def build_guest_user
    user = User.new(:builder_id => id)
    user.invitation_code = init_invitation_code
    user.deadline = Time.now + 1.month
    user.save
    user
  end

  def self.build_or_find_common_user(email)
    user = User.where(:email => email).first_or_initialize(:user_type => 'Common')
    user.set_password(User.init_password) if user.new_record?
    user.save
    user
  end

  #guest 用户暂时使用默认密码。
  def init_password
    set_password("leap4_net") if user_type == 'Guest'
  end

  def within_deadline?
    deadline > Time.now
  end

  def is_common?
    user_type == 'Common'
  end

  def is_guest?
    user_type == 'Guest' || name == 'guest'
  end

  def nick_name
    is_guest? ? 'guest' : email
  end

  def all_remaining_days
    days = 0
    orders.each { |o| days += o.remaining_days }
    days
  end

  #总截止日期
  def all_deadline
    (Time.now + all_remaining_days.send('days')).strftime("%Y-%m-%d")
  end

  #是否快要到期
  def close_to_deadline?
    all_remaining_days < 2 && all_remaining_days > 0
  end

  #拿出最后一个订单的购买时间
  def invoice_date
    orders.order('created_at desc').first.buy_date.strftime("%Y-%m-%d") if orders.present?
  end

  def rewrite_password
    if self.cleartext_password_changed?
      delete_line_text
      write_vpn_pass
    end
  end

  # 删除vpn_password已有帐户
  def delete_line_text
    require 'fileutils'
    require 'tempfile'
    # binding.pry
    file = File.readlink(Rails.root.join("config", 'vpn_password').to_s)
    tmp = Tempfile.new("extract")
    open(file, 'r').each do |line|
      tmp << line unless line.chomp == "#{nick_name} * #{cleartext_password_was} *"
    end
    tmp.close
    FileUtils.mv(tmp.path, file)
  end

  # 写密码到vpn_password
  def write_vpn_pass
    file = File.readlink(Rails.root.join('config', 'vpn_password'))
    content = "#{nick_name} * #{cleartext_password} *"
    File.open(file, "a+") { |f| f.puts "#{content}\n" }
  end

end
