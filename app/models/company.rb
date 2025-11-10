class Company < ApplicationRecord
  has_many :users, dependent: :restrict_with_error
  has_many :vehicles, dependent: :destroy
  has_many :assignments, dependent: :destroy
  has_many :incidents, dependent: :destroy
  has_many :drivers, -> { where(role: :driver) }, class_name: "User"

  validates :name, presence: true, uniqueness: true
end
