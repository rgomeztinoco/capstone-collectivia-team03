class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.welcome_email.subject
  #
  def welcome_email
    # attachments.inline['image.jpg'] = File.read('/app/assets/images/welcome.jpg')
    @user = params[:user]
    @url = 'https://www.micolet.com/'

    attachments.inline['welcome.png'] = File.read('app/assets/images/micolet-logo.png')

    p "========================="
    pp @user
    p "========================="
    mail(to: @user.email, subject: 'You are successfully registered')
  end
end
