class User < ApplicationRecord
  # Associations
  has_and_belongs_to_many :topics, join_table: :subscriptions

  # Validations
  validates :email,
            uniqueness: true,
            presence: true,
            format: {
              with: URI::MailTo::EMAIL_REGEXP,
              message: I18n.t("invalid_format")
            }
  validates :topics, presence: { message: :select_you }
end
