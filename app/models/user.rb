class User < ApplicationRecord
  # Associations
  has_and_belongs_to_many :topics, join_table: :subscriptions

  # Validations
  validates :email,
            uniqueness: true,
            presence: true,
            format: {
              with: URI::MailTo::EMAIL_REGEXP,
              message: "invalid format"
            }
  validates :topics, presence: { message: "you must select at least one" }
end
