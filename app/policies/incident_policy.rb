class IncidentPolicy < ApplicationPolicy
  # Admins have full access to everything
  # Managers can view, update, and manage all incidents within their company
  # Drivers can create incidents and view their own incidents, but cannot edit after creation

  def index?
    true # All authenticated users can view the list (scoped in controller)
  end

  def show?
    return true if user.admin?
    return true if user.manager? && user.company_id == record.company_id
    # Drivers can only see incidents they reported
    user.driver? && record.reporter_id == user.id
  end

  def create?
    # Drivers, managers, and admins can create incidents
    true
  end

  def new?
    create?
  end

  def update?
    return true if user.admin?
    # Only managers can update incidents (drivers cannot edit after creation)
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
        # Drivers can only see incidents they reported
        scope.where(reporter_id: user.id)
      else
        scope.none
      end
    end
  end
end
