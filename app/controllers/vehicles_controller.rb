class VehiclesController < ApplicationController
  before_action :set_vehicle, only: [:show, :edit, :update, :destroy]

  def index
    @vehicles = Vehicle.all
  end

  def show
  end

  def new
    @vehicle = Vehicle.new
  end

  def edit
  end

  def create
    @vehicle = Vehicle.new(vehicle_params)

    if @vehicle.save
      redirect_to @vehicle, notice: "Vehicle was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @vehicle.update(vehicle_params)
      redirect_to @vehicle, notice: "Vehicle was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @vehicle.destroy
    redirect_to vehicles_url, notice: "Vehicle was successfully destroyed."
  end

  private

  def set_vehicle
    @vehicle = Vehicle.find(params[:id])
  end

  def vehicle_params
    params.require(:vehicle).permit(:make, :model, :year, :color, :license_plate, :vin)
  end
end
