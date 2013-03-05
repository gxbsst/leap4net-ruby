ActionMailer::Base.smtp_settings = {
    :address              => "mail.sidways.com",
    :port                 => 25,
    :domain               => 'leap4.net',
    :user_name            => 'patrick_contact@sidways.com',
    :password             => '123456',
    :authentication       => :login,
    :enable_starttls_auto => true
}