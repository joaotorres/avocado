class IncidentsController < ApplicationController
  before_action :set_company
  before_action :set_incident, only: [:show, :edit, :update, :destroy]
  before_action :authorize_incident, except: [:index]

  def index
    authorize Incident
    @incidents = policy_scope(Incident).where(company: @company).includes(:vehicle, :reporter).recent
  end

  def show
  end

  def new
    @incident = @company.incidents.new

    # Pre-populate from assignment if provided
    if params[:assignment_id].present?
      assignment = @company.assignments.find(params[:assignment_id])
      @incident.vehicle = assignment.vehicle
      @incident.date = assignment.date
    elsif params[:vehicle_id].present?
      @incident.vehicle = @company.vehicles.find(params[:vehicle_id])
      @incident.date = Date.current
    end

    authorize @incident
  end

  def edit
  end

  def create
    @incident = @company.incidents.new(incident_params)
    @incident.reporter = current_user
    authorize @incident

    if @incident.save
      redirect_to company_incident_path(@company, @incident), notice: "Incident was successfully reported."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @incident.update(incident_params)
      redirect_to company_incident_path(@company, @incident), notice: "Incident was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @incident.destroy
    redirect_to company_incidents_url(@company), notice: "Incident was successfully deleted."
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

  def set_incident
    @incident = policy_scope(Incident).where(company: @company).find(params[:id])
  end

  def authorize_incident
    authorize @incident || Incident
  end

  def incident_params
    params.require(:incident).permit(:vehicle_id, :date, :category, :description, :status, :cost)
  end
end
