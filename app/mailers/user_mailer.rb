class UserMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.welcome_email.subject
  #
  def welcome_email
    # attachments.inline['image.jpg'] = File.read('/app/assets/images/welcome.jpg')
    @user = params[:user]
    @topics = @user.topics.map { |topic| t("models.topics.names.#{topic.id}") }
    @url = "https://www.micolet.com/"

    attachments.inline["welcome.png"] = File.read("app/assets/images/micolet-logo.png")

    mail(to: @user.email, subject: t("email.welcome_subject"))
  end
end
