require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should not save user without email" do
    user = User.new(topic_ids: [1])
    assert_not(user.save, "expected to not save user without email")
  end

  test "should not save user without topics" do
    user = User.new(email: "valid@email.com")
    assert_not(user.valid?, "expected user to be invalid without topics")
    assert_not_nil(user.errors[:topics], "no validation error for topic present")
  end

  test "shoud not save with duplicated email" do
    user_in_db = users(:one)
    user = User.new(email: user_in_db.email, topic_ids: [1])
    assert_not(user.save, "expected to not save user with duplicated email")
  end

  test "shoud not save with invalid format email" do
    user = User.new(email: "sadfasdf", topic_ids: [1])
    assert_not(user.save, "expected to not save user with invalid email")
  end

  test "can save valid user" do
    user = User.new(email: "valid@email.com", topic_ids: [1])
    assert(user.save, "expected to be able to save valid user")
  end
end
