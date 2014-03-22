class Confirmation < ActionMailer::Base
  def thanks(email, name)
    recipients email
    from "ilya.bazylchuk@gmail.com"
    subject "Thanks for signing up!"
    sent_on Time.now
    body :name => name
  end

end
