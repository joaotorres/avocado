class AssignmentsController < ApplicationController
  before_action :set_company
  before_action :set_assignment, only: [:show, :edit, :update, :destroy]
  before_action :authorize_assignment, except: [:index]

  def index
    authorize Assignment
    @assignments = policy_scope(Assignment).where(company: @company).includes(:driver, :vehicle).order(date: :desc)
  end

  def show
  end

  def new
    @assignment = @company.assignments.new
    authorize @assignment
  end

  def edit
  end

  def create
    @assignment = @company.assignments.new(assignment_params)
    authorize @assignment

    if @assignment.save
      redirect_to [@company, @assignment], notice: "Assignment was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @assignment.update(assignment_params)
      redirect_to [@company, @assignment], notice: "Assignment was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @assignment.destroy
    redirect_to company_assignments_url(@company), notice: "Assignment was successfully destroyed."
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

  def set_assignment
    @assignment = policy_scope(Assignment).where(company: @company).find(params[:id])
  end

  def authorize_assignment
    authorize @assignment || Assignment
  end

  def assignment_params
    params.require(:assignment).permit(:driver_id, :vehicle_id, :date)
  end
end
