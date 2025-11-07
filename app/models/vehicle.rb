class Vehicle < ApplicationRecord
  validates :make, presence: true
  validates :model, presence: true
  validates :year, presence: true, numericality: { only_integer: true }
  validates :color, presence: true
  validates :license_plate, presence: true, uniqueness: true
  validates :vin, presence: true, uniqueness: true
end
