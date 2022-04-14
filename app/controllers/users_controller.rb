class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]

  def show; end

  def new
    
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.validate
      response = email_verification_request(@user.email)

      unless response[:autocorrect].empty?
        @user.errors.add(:email, "#{t('.did_you_mean')} #{response[:autocorrect]}")
        return render :new, status: :unprocessable_entity
      end

      if response[:quality_score].to_f >= 0.7
        @user.save
        redirect_to @user, notice: "#{t('.title_subscribe_correct')}"
      else
        @user.errors.add(:email, "#{t('.title_email_unreal')}")
        render :new, status: :unprocessable_entity
      end
    else
      render :new, status: :unprocessable_entity
    end
  rescue HTTParty::ResponseError => e
    flash[:alert] = JSON.parse(e.message)["error"]["message"]
    render :new, status: :unprocessable_entity
  end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: "#{t('.title_subscribe_update')}"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    redirect_to :root, notice: "#{t('.title_subscribe_cancel')}"
  end

  private

  def email_verification_request(email)
    base_uri = "https://emailvalidation.abstractapi.com/v1/"
    query = {
      api_key: ENV["EMAIL_VALIDATION_API_KEY"],
      email: email
    }
    response = HTTParty.get(base_uri, query: query)
    raise(HTTParty::ResponseError, response) unless response.success?

    JSON.parse(response.body, symbolize_names: true)
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:email, topic_ids: [])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end
end
