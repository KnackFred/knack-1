ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address        => 'smtp.gmail.com',
  :port           => 465,
  :domain         => 'smtp.gmail.com',
  :authentication => 'ilya.bazylchuk@gmail.com',
  :user_name      => 'ilya.bazylchuk@gmail.com',
  :password       => '1qazxsw2'
}