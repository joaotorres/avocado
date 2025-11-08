class VehiclePolicy < ApplicationPolicy
  # Admins have full access to everything across all companies
  # Managers can view, create, update, and delete vehicles within their company
  # Drivers can only view vehicles within their company

  def index?
    true # All authenticated users can view the list (scoped by company in controller)
  end

  def show?
    return true if user.admin?
    return false unless record.company_id
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
      else
        scope.where(company_id: user.company_id)
      end
    end
  end
end
