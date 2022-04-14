require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "should get new" do
    get new_user_url

    assert_response :success
  end

  test "should create user" do
    assert_difference("User.count") do
      post users_url, params: { user: { email: "validemail@gmail.com", topic_ids: [1] } }
      # Workarround to the API 1 request per second limit
      sleep 1
    end

    assert_redirected_to user_url(User.last)
    assert_equal "Your subscription was succesfully created", flash[:notice]
  end

  test "should not create user with email that score less than 0.7 in the API" do
    assert_no_difference("User.count") do
      post users_url, params: { user: { email: "invalidemail@invalid.com", topic_ids: [1] } }
      # Workarround to the API 1 request per second limit
      sleep 1
    end

    assert_response :unprocessable_entity
  end

  test "should show user" do
    get user_url(@user)

    assert_response :success
  end

  test "should get edit" do
    get edit_user_url(@user)

    assert_response :success
  end

  test "should update user with new topics" do
    patch user_url(@user), params: { user: { topic_ids: [1, 2] } }
    assert_redirected_to user_url(@user)

    assert_equal "Your subscription was succesfully updated", flash[:notice]
  end

  test "should not update user without topics" do
    patch user_url(@user), params: { user: { topic_ids: [] } }

    assert_response :unprocessable_entity
  end

  test "should destroy user" do
    assert_difference("User.count", -1) do
      delete user_url(@user)
    end

    assert_redirected_to "/"
    assert_equal "Your suscription has been canceled", flash[:notice]
  end
end
