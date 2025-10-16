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

ActiveRecord::Schema[8.0].define(version: 2025_10_16_134842) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "casks", force: :cascade do |t|
    t.bigint "owner_id", null: false
    t.bigint "location_id", null: false
    t.string "cask_number", null: false
    t.text "description"
    t.string "spirit_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cask_number"], name: "index_casks_on_cask_number"
    t.index ["location_id"], name: "index_casks_on_location_id"
    t.index ["owner_id"], name: "index_casks_on_owner_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "owner_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id"], name: "index_companies_on_owner_id"
  end

  create_table "locations", force: :cascade do |t|
    t.bigint "warehouse_id", null: false
    t.string "area"
    t.string "shelf"
    t.string "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["warehouse_id"], name: "index_locations_on_warehouse_id"
  end

  create_table "relocation_requests", force: :cascade do |t|
    t.bigint "cask_id", null: false
    t.bigint "requester_id", null: false
    t.bigint "from_location_id", null: false
    t.bigint "to_location_id"
    t.integer "status", default: 0, null: false
    t.datetime "requested_at"
    t.datetime "completed_at"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cask_id"], name: "index_relocation_requests_on_cask_id"
    t.index ["from_location_id"], name: "index_relocation_requests_on_from_location_id"
    t.index ["requester_id"], name: "index_relocation_requests_on_requester_id"
    t.index ["status"], name: "index_relocation_requests_on_status"
    t.index ["to_location_id"], name: "index_relocation_requests_on_to_location_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "name"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "valuations", force: :cascade do |t|
    t.bigint "cask_id", null: false
    t.decimal "amount"
    t.date "valuation_date"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cask_id"], name: "index_valuations_on_cask_id"
  end

  create_table "warehouse_staff_assignments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "warehouse_id", null: false
    t.integer "role"
    t.boolean "can_move_casks"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_warehouse_staff_assignments_on_user_id"
    t.index ["warehouse_id"], name: "index_warehouse_staff_assignments_on_warehouse_id"
  end

  create_table "warehouses", force: :cascade do |t|
    t.string "name"
    t.text "address"
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_warehouses_on_company_id"
  end

  add_foreign_key "casks", "locations"
  add_foreign_key "casks", "users", column: "owner_id"
  add_foreign_key "companies", "users", column: "owner_id"
  add_foreign_key "locations", "warehouses"
  add_foreign_key "relocation_requests", "casks"
  add_foreign_key "relocation_requests", "locations", column: "from_location_id"
  add_foreign_key "relocation_requests", "locations", column: "to_location_id"
  add_foreign_key "relocation_requests", "users", column: "requester_id"
  add_foreign_key "valuations", "casks"
  add_foreign_key "warehouse_staff_assignments", "users"
  add_foreign_key "warehouse_staff_assignments", "warehouses"
  add_foreign_key "warehouses", "companies"
end
