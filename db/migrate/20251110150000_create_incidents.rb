class CreateIncidents < ActiveRecord::Migration[8.1]
  def change
    create_table :incidents do |t|
      t.references :vehicle, null: false, foreign_key: true
      t.references :reporter, null: false, foreign_key: { to_table: :users }
      t.references :company, null: false, foreign_key: true
      t.date :date, null: false
      t.integer :category, null: false
      t.text :description, null: false
      t.integer :status, null: false, default: 0
      t.decimal :cost, precision: 10, scale: 2

      t.timestamps
    end

    add_index :incidents, [:company_id, :date]
    add_index :incidents, [:vehicle_id, :date]
  end
end
