class Topic < ApplicationRecord
  # Associations
  has_and_belongs_to_many :users, join_table: :subscriptions

  # Validations
  validates :name, uniqueness: true, presence: true
end
