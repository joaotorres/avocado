class Vehicle < ApplicationRecord
  belongs_to :company

  validates :make, presence: true
  validates :model, presence: true
  validates :year, presence: true, numericality: { only_integer: true }
  validates :color, presence: true
  validates :license_plate, presence: true, uniqueness: { scope: :company_id }, format: {
    with: /\A[A-Z]{2}\d{2}[A-Z]{3}\z/,
    message: "must be in UK format (e.g., AB12CDE)"
  }
  validates :vin, presence: true, uniqueness: { scope: :company_id }
  validates :company_id, presence: true
end
