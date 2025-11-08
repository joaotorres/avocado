class CompaniesController < ApplicationController
  before_action :set_company, only: [:show, :edit, :update, :destroy]
  before_action :authorize_company, except: [:index]

  def index
    authorize Company
    @companies = Company.all
  end

  def show
  end

  def new
    @company = Company.new
    authorize @company
  end

  def edit
  end

  def create
    @company = Company.new(company_params)
    authorize @company

    if @company.save
      redirect_to @company, notice: "Company was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @company.update(company_params)
      redirect_to @company, notice: "Company was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @company.destroy
    redirect_to companies_url, notice: "Company was successfully deleted."
  end

  private

  def set_company
    @company = Company.find(params[:id])
  end

  def authorize_company
    authorize @company
  end

  def company_params
    params.require(:company).permit(:name)
  end
end
