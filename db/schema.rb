# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2025_11_10_150000) do
  create_table "assignments", force: :cascade do |t|
    t.integer "company_id", null: false
    t.datetime "created_at", null: false
    t.date "date", null: false
    t.integer "driver_id", null: false
    t.datetime "updated_at", null: false
    t.integer "vehicle_id", null: false
    t.index ["company_id"], name: "index_assignments_on_company_id"
    t.index ["driver_id", "date"], name: "index_assignments_on_driver_id_and_date", unique: true
    t.index ["driver_id"], name: "index_assignments_on_driver_id"
    t.index ["vehicle_id", "date"], name: "index_assignments_on_vehicle_id_and_date", unique: true
    t.index ["vehicle_id"], name: "index_assignments_on_vehicle_id"
  end

  create_table "companies", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "incidents", force: :cascade do |t|
    t.integer "category", null: false
    t.integer "company_id", null: false
    t.decimal "cost", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.date "date", null: false
    t.text "description", null: false
    t.integer "reporter_id", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.integer "vehicle_id", null: false
    t.index ["company_id", "date"], name: "index_incidents_on_company_id_and_date"
    t.index ["company_id"], name: "index_incidents_on_company_id"
    t.index ["reporter_id"], name: "index_incidents_on_reporter_id"
    t.index ["vehicle_id", "date"], name: "index_incidents_on_vehicle_id_and_date"
    t.index ["vehicle_id"], name: "index_incidents_on_vehicle_id"
  end

  create_table "users", force: :cascade do |t|
    t.integer "company_id"
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "role", default: 2, null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vehicles", force: :cascade do |t|
    t.string "color"
    t.integer "company_id"
    t.datetime "created_at", null: false
    t.string "license_plate"
    t.string "make"
    t.string "model"
    t.datetime "updated_at", null: false
    t.string "vin"
    t.integer "year"
    t.index ["company_id"], name: "index_vehicles_on_company_id"
  end

  add_foreign_key "assignments", "companies"
  add_foreign_key "assignments", "users", column: "driver_id"
  add_foreign_key "assignments", "vehicles"
  add_foreign_key "incidents", "companies"
  add_foreign_key "incidents", "users", column: "reporter_id"
  add_foreign_key "incidents", "vehicles"
  add_foreign_key "users", "companies"
  add_foreign_key "vehicles", "companies"
end
