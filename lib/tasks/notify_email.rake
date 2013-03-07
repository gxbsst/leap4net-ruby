#encoding: utf-8
namespace :notify_email do
  
  #将所有的订单变成成功订单。
  task :send_users => :environment do
    user_ids = []
    User.where(:user_type => 'Common').all.each do |u|
      if u.close_to_deadline?
        user_ids << u.id
      end
    end
    if user_ids.present?
      users = User.find(user_ids)
      UserMailer.send_approaching_deadline_users(users).deliver
    end
  end
end