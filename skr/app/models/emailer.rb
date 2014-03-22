class Emailer < ActionMailer::Base
  def contact(recipient, subject, message, sent_at = Time.now)
      @subject = subject
      @recipients = recipient
      @from = 'ilya.bazylchuk@gmail.com'
      @sent_on = sent_at
	  @body["title"] = 'This is title'
  	  @body["email"] = 'ilya.bazylchuk@gmail.com'
   	  @body["message"] = message
      @headers = {}
   end

  def late_timesheet(user, week_of)
    recipients user.email
    subject "Something something"
    from "support@knackregistry.com"
    body :recipient => user.name, :week => week_of
  end

end
