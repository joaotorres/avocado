class CreateVehicles < ActiveRecord::Migration[8.1]
  def change
    create_table :vehicles do |t|
      t.string :make
      t.string :model
      t.integer :year
      t.string :color
      t.string :license_plate
      t.string :vin

      t.timestamps
    end
  end
end
