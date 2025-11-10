class CreateAssignments < ActiveRecord::Migration[8.1]
  def change
    create_table :assignments do |t|
      t.references :driver, null: false, foreign_key: { to_table: :users }
      t.references :vehicle, null: false, foreign_key: true
      t.references :company, null: false, foreign_key: true
      t.date :date, null: false

      t.timestamps
    end

    add_index :assignments, [:driver_id, :date], unique: true
    add_index :assignments, [:vehicle_id, :date], unique: true
  end
end
