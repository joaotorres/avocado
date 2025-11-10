class VehiclesController < ApplicationController
  before_action :set_company
  before_action :set_vehicle, only: [:show, :edit, :update, :destroy]
  before_action :authorize_vehicle, except: [:index]

  def index
    authorize Vehicle
    @vehicles = scoped_vehicles
  end

  def show
  end

  def new
    @vehicle = scoped_vehicles.new
  end

  def edit
  end

  def create
    @vehicle = scoped_vehicles.new(vehicle_params)

    if @vehicle.save
      redirect_to [@company, @vehicle], notice: "Vehicle was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @vehicle.update(vehicle_params)
      redirect_to [@company, @vehicle], notice: "Vehicle was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @vehicle.destroy
    redirect_to company_vehicles_url(@company), notice: "Vehicle was successfully destroyed."
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

  def scoped_vehicles
    @company.vehicles
  end

  def set_vehicle
    @vehicle = scoped_vehicles.find(params[:id])
  end

  def authorize_vehicle
    authorize @vehicle || Vehicle
  end

  def vehicle_params
    params.require(:vehicle).permit(:make, :model, :year, :color, :license_plate, :vin)
  end
end
