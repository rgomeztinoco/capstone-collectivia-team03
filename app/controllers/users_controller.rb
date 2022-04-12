class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def edit
    @user = User.find_by(email: params[:email])
  end

  def create
    @user = User.new(user_params)
    response = email_verification_request(@user.email)
    if response.quality_score.to_i >= 0.7
      if @user.save
        render success_page
      else
        render error_page
      end
    else
      render error_page
    end
  end

  def update
    @user = User.find_by(email: params[:email])

    if @user.update(user_params)
      render success_page
    else
      render error_page
    end
  end

  private

  def email_verification_request(email)
    base_uri = "https://emailvalidation.abstractapi.com/v1/"
    query = {
      api_key: ENV.EMAIL_VALIDATION_API_KEY,
      email: email
    }
    response = HTTParty.get(base_uri, query: query)
    JSON.parse(response.body)
  end

  def user_params
    params.require(:user).permit(:email)
  end
end
