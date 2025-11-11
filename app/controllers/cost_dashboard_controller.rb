class CostDashboardController < ApplicationController
  before_action :set_company
  before_action :authorize_access

  def index
    # Get the date of the first vehicle created for this company
    first_vehicle_date = @company.vehicles.minimum(:created_at)

    if first_vehicle_date.present?
      start_date = first_vehicle_date.beginning_of_month
      end_date = Date.current.end_of_month

      @monthly_costs = []
      current_month = start_date

      while current_month <= end_date
        month_start = current_month.beginning_of_month
        month_end = current_month.end_of_month

        total_cost = @company.incidents
                             .where(date: month_start..month_end)
                             .sum(:cost) || 0

        @monthly_costs << {
          date: current_month,
          total_cost: total_cost,
          incident_count: @company.incidents.where(date: month_start..month_end).count
        }

        current_month = current_month.next_month
      end

      @monthly_costs.reverse! # Most recent first
    else
      @monthly_costs = []
    end
  end

  def month
    @year = params[:year].to_i
    @month = params[:month].to_i

    @date = Date.new(@year, @month, 1)
    month_start = @date.beginning_of_month
    month_end = @date.end_of_month

    @incidents = @company.incidents
                         .includes(:vehicle, :reporter)
                         .where(date: month_start..month_end)
                         .order(date: :desc)

    @total_cost = @incidents.sum(:cost) || 0
  end

  private

  def set_company
    @company = Company.find(params[:company_id])
    # Ensure non-admin users can only access their own company
    unless current_user.admin? || @company == current_company
      flash[:alert] = "You are not authorized to access this company."
      redirect_to root_path
    end
  end

  def authorize_access
    unless current_user.manager? || current_user.admin?
      flash[:alert] = "You are not authorized to access the cost dashboard."
      redirect_to root_path
    end
  end
end
