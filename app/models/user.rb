class User < ActiveRecord::Base
  attr_accessible :name, :user_type, :email, :password_confirmation
  has_secure_password
  validates_presence_of :password, :on => :create
  validates :user_type, :presence => true

  def set_password(password)
    self.password = password
    self.password_confirmation = password
    self.cleartext_password = password
  end
end
