
class StaticPagesController < ApplicationController
  def why_vpn
  end

  def setup_howto
  end

  def login
  end

  def index
  end

  def contactus
  end

  def faq
    ::I18n.locale = 'zh'
  end
end
