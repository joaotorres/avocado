# DriversController manages User records with role: driver
# This is a virtual resource - drivers aren't a separate model,
# but rather a filtered view of the User model
class DriversController < ApplicationController
  before_action :set_company
  before_action :set_driver, only: [:show, :edit, :update, :destroy]

  def index
    authorize User, policy_class: DriverPolicy
    @drivers = @company.drivers.order(:name)
  end

  def show
    authorize @driver, policy_class: DriverPolicy
  end

  def new
    @driver = @company.users.new(role: :driver)
    authorize @driver, policy_class: DriverPolicy
  end

  def edit
    authorize @driver, policy_class: DriverPolicy
  end

  def create
    @driver = @company.users.new(driver_params)
    @driver.role = :driver
    authorize @driver, policy_class: DriverPolicy

    if @driver.save
      redirect_to company_driver_path(@company, @driver), notice: "Driver was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    authorize @driver, policy_class: DriverPolicy

    # Remove password from params if blank
    update_params = driver_params
    if update_params[:password].blank?
      update_params = update_params.except(:password, :password_confirmation)
    end

    if @driver.update(update_params)
      redirect_to company_driver_path(@company, @driver), notice: "Driver was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @driver, policy_class: DriverPolicy
    @driver.destroy
    redirect_to company_drivers_url(@company), notice: "Driver was successfully removed."
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

  def set_driver
    @driver = @company.users.where(role: :driver).find(params[:id])
  end

  def driver_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
