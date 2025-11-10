class AssignmentPolicy < ApplicationPolicy
  # Admins have full access to everything across all companies
  # Managers can create, view, update, and delete assignments within their company
  # Drivers can only view their own assignments

  def index?
    true # All authenticated users can view the list (scoped by policy in controller)
  end

  def show?
    return true if user.admin?
    return true if user.manager? && user.company_id == record.company_id
    # Drivers can only see their own assignments
    user.driver? && record.driver_id == user.id
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
    return false unless record.company_id
    user.company_id == record.company_id
  end

  def edit?
    update?
  end

  def destroy?
    return true if user.admin?
    return false unless user.manager?
    return false unless record.company_id
    user.company_id == record.company_id
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin?
        scope.all
      elsif user.manager?
        scope.where(company_id: user.company_id)
      elsif user.driver?
        # Drivers can only see their own assignments
        scope.where(driver_id: user.id)
      else
        scope.none
      end
    end
  end
end
