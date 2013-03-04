#encoding: utf-8
class User < ActiveRecord::Base
  # user_type Guest、 Commom、Disabled
  #guest 默认密码为"leap4_net"
  attr_accessible :name, :user_type, :email, :password_confirmation, :password, :builder_id
  has_secure_password
  validates :password, :presence => true, :on => :create
  validates :user_type, :presence => true
  validates :invitation_code, :deadline, :presence => true, :if => "user_type == 'Guest'"
  before_validation :init_password

  has_many :orders
  
  def set_password(password)
    self.password = password
    self.password_confirmation = password
    self.cleartext_password = password
  end
 
  #生成50位包含大小写得随机字符串。
  def init_invitation_code
    o =  [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten
    (0...50).map{ o[rand(o.length)] }.join
  end

  def build_guest_user
    u = User.new(:builder_id => id)
    u.invitation_code = init_invitation_code
    u.deadline = Time.now + 1.month
    u.save
    u
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
    is_guest? ? 'Guest' : email
  end
end
