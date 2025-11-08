class Company < ApplicationRecord
  has_many :users, dependent: :restrict_with_error
  has_many :vehicles, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
