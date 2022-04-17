require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "can send welcome email" do
    user = User.create(email: "valid@email.com", topic_ids: [1])

    mail = UserMailer.with(user: user).welcome_email

    assert_emails 1 do
      mail.deliver_now
    end

    assert_equal I18n.t("email.welcome_subject"), mail.subject
    assert_equal [user.email], mail.to
    assert_equal [ENV["GMAIL_COLLECTIVIA"]], mail.from
  end
end
