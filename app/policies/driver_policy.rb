class DriverPolicy < ApplicationPolicy
  # This policy manages User records with role: driver
  # Admins have full access to all drivers across all companies
  # Managers can manage drivers (User records with role: driver) within their company
  # Regular users cannot manage drivers

  def index?
    user.admin? || user.manager?
  end

  def show?
    return true if user.admin?
    return false unless user.manager?
    return false if record == User || record.nil?
    return false unless record.company_id
    # Ensure the record is actually a driver
    return false unless record.driver?
    user.company_id == record.company_id
  end

  def create?
    user.admin? || user.manager?
  end

  def new?
    create?
  end

  def update?
    return true if user.admin?
    return false unless user.manager?
    return false if record == User || record.nil?
    return false unless record.company_id
    # Ensure the record is actually a driver
    return false unless record.driver?
    user.company_id == record.company_id
  end

  def edit?
    update?
  end

  def destroy?
    return true if user.admin?
    return false unless user.manager?
    return false if record == User || record.nil?
    return false unless record.company_id
    # Don't allow deleting yourself
    return false if record.id == user.id
    # Ensure the record is actually a driver
    return false unless record.driver?
    user.company_id == record.company_id
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin?
        scope.where(role: :driver)
      elsif user.manager?
        scope.where(company_id: user.company_id, role: :driver)
      else
        scope.none
      end
    end
  end
end
