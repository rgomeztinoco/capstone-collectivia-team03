class ApplicationMailer < ActionMailer::Base
  default from: ENV["GMAIL_COLLECTIVIA"]
  layout "mailer"
end
