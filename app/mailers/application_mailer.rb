# Action Mailer allows you to send email from your application using a mailer
# model and views.
class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'
end
