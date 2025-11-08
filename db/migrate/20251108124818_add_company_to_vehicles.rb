class AddCompanyToVehicles < ActiveRecord::Migration[8.1]
  def change
    add_reference :vehicles, :company, null: true, foreign_key: true
  end
end
