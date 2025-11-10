class Incident < ApplicationRecord
  belongs_to :vehicle
  belongs_to :reporter, class_name: "User"
  belongs_to :company

  enum :category, {
    mechanical_issue: 0,
    electrical_issue: 1,
    body_damage: 2,
    interior_issue: 3,
    accident_or_collision: 4,
    flat_tire: 5,
    missing_or_damaged_equipment: 6,
    other: 7
  }

  enum :status, {
    open: 0,
    in_progress: 1,
    resolved: 2,
    dismissed: 3
  }

  validates :date, presence: true
  validates :category, presence: true
  validates :description, presence: true
  validates :status, presence: true
  validates :company_id, presence: true
  validates :cost, numericality: { greater_than_or_equal_to: 0, allow_nil: true }

  # Ensure reporter belongs to the same company
  validate :reporter_belongs_to_company
  validate :vehicle_belongs_to_company

  scope :for_vehicle, ->(vehicle) { where(vehicle: vehicle) }
  scope :recent, -> { order(date: :desc, created_at: :desc) }
  scope :by_status, ->(status) { where(status: status) }

  def self.human_category_name(category)
    category.to_s.humanize.titleize
  end

  def category_name
    self.class.human_category_name(category)
  end

  private

  def reporter_belongs_to_company
    if reporter && company && reporter.company_id != company_id
      errors.add(:reporter, "must belong to the same company")
    end
  end

  def vehicle_belongs_to_company
    if vehicle && company && vehicle.company_id != company_id
      errors.add(:vehicle, "must belong to the same company")
    end
  end
end
