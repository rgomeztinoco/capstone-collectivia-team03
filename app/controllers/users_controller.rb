class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]
  before_action :set_topics, only: %i[new create update edit]

  def show; end

  def new
    
    @user = User.new
  end

  def create
    @user = User.new(user_params_new)

    if @user.valid?
      response = email_verification_request(@user.email)

      unless response[:autocorrect].empty?
        @user.errors.add(:email, "#{t('.did_you_mean')} #{response[:autocorrect]}")
        return render :new, status: :unprocessable_entity
      end

      if response[:quality_score].to_f >= 0.7
        @user.save
        UserMailer.with(user: @user).welcome_email.deliver_later
        redirect_to @user, notice: t(".subscribed_notice")
      else
        @user.errors.add(:email, t(".title_email_false"))
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
    if @user.update(user_params_edit)
      redirect_to @user, notice: t(".updated_notice")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    redirect_to :root, notice: t(".canceled_notice")
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
  def user_params_new
    params.require(:user).permit(:email, topic_ids: [])
  end

  def user_params_edit
    params.require(:user).permit(topic_ids: [])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  def set_topics
    topics = Topic.all.map do |topic|
      JSON.parse(topic.to_json, symbolize_names: true)
    end
    @topics_with_i18n = topics.map do |topic|
      [topic[:id], t("models.topics.names.#{topic[:id]}")]
    end
  end
end
