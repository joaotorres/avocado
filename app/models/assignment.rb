class Assignment < ApplicationRecord
  belongs_to :driver, class_name: "User"
  belongs_to :vehicle
  belongs_to :company

  validates :date, presence: true
  validates :driver_id, uniqueness: { scope: :date, message: "already has an assignment for this date" }
  validates :vehicle_id, uniqueness: { scope: :date, message: "is already assigned for this date" }
  validates :company_id, presence: true

  # Ensure driver belongs to the same company
  validate :driver_belongs_to_company
  validate :vehicle_belongs_to_company
  validate :driver_has_driver_role

  scope :for_date, ->(date) { where(date: date) }
  scope :upcoming, -> { where("date >= ?", Date.current).order(date: :asc) }
  scope :past, -> { where("date < ?", Date.current).order(date: :desc) }

  private

  def driver_belongs_to_company
    if driver && company && driver.company_id != company_id
      errors.add(:driver, "must belong to the same company")
    end
  end

  def vehicle_belongs_to_company
    if vehicle && company && vehicle.company_id != company_id
      errors.add(:vehicle, "must belong to the same company")
    end
  end

  def driver_has_driver_role
    if driver && !driver.driver?
      errors.add(:driver, "must have the driver role")
    end
  end
end
