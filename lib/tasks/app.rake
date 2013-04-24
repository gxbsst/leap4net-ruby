# encoding: utf-8
namespace :app do
  # usage: Usage: rake notify_email:create_user email=name@example.com duration=day|year|month
  desc "创建VPN用户"
  task :create_user => :environment do

    unless ENV['email'].present? && ['duration'].present?
      puts "Usage: rake notify_email:create_user email=name@example.com duration=day|year|month"
    end

    email, duration = ENV['email'], ENV['duration']

    if duration == 'day'
      d = 1.day
    elsif duration == 'year'
      d = 1.year
    elsif duration == 'month'
      d = 30.days
    end

    user = ::User.build_or_find_common_user(email)
    UserMailer.new_user(user).deliver
    @order = Order.new(
        :buy_date => Time.now,
        :deadline => Time.now + d,
        :pay_price => 0,
        :status => 'success',
        :leap_type => duration,
        :user_id => user.id,
        :so => SecureRandom.hex,
        :name => 'leap4net',
        :qty => 1,
        :description => '免费用户',
        :shipping_rate => 0,
        :tax_rate => 0,
        :saleoff_code => 'free',
        :billing_method => 'free',
        :email => email
    )

    puts "创建成功" if @order.save

    #UserMailer.order(@order, @order.user).deliver

  end

end
