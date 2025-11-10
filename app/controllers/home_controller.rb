class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    if user_signed_in?
      if current_user.admin?
        redirect_to companies_path
      elsif current_company
        if current_user.manager?
          redirect_to company_vehicles_path(current_company)
        elsif current_user.driver?
          redirect_to company_assignments_path(current_company)
        else
          redirect_to company_assignments_path(current_company)
        end
      else
        flash[:alert] = "You are not associated with any company."
        redirect_to root_path
      end
    end
  end
end
