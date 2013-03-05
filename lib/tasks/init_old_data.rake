#encoding: utf-8
namespace :init_old_data do

  task :init_all_data => [:init_users, :init_orders] do

  end
  desc '导入用户'
  task :init_users => :environment do
    puts "================= begin"
    require 'csv'
    file = Rails.root.join("lib", "tasks", "data", "leap_user_view.csv")
    csv = CSV.read(file)
    csv.each_with_index do |v, i|
      next if i == 0
      user = User.where(:email => v[1]).
                  first_or_initialize(:user_type => 'Common')
      if user.new_record?
        user.set_password v[2]
        user.updated_at = user.created_at = v[3]
        user.invitation_code = v[0] #临时存放原user_id
        user.save
        puts user.id
      end
    end
  end


  desc '导入订单'
  task :init_orders => :environment do
    puts "================== begin"
    require 'csv'
    file = Rails.root.join("lib", "tasks", "data", "leap_order_view.csv")
    csv = CSV.read(file)
    csv.each_with_index do |v, i|
      next if i == 0
      user = User.find_by_invitation_code(v[5])
      if user
        order = user.orders.new
        order.leap_type = v[1].downcase
        order.pay_price = v[2]
        order.buy_date = order.updated_at = order.created_at = v[3]
        order.user = user
        order.email = user.email
        order.deadline = v[6]
        order.is_old_order = true
        order.save
        puts "#{v[2]} order.id #{order.pay_price}"
      else
        puts "[#{i}] can't find user."
      end
    end
  end
end