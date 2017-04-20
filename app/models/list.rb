class List < ApplicationRecord
  belongs_to :user
  has_many :users, through: :list_subscribers
  has_many :tasks
end
