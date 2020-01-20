# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_01_20_164920) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "data_infos", force: :cascade do |t|
    t.jsonb "chart_info"
    t.jsonb "min_max"
    t.string "data_portion_type", null: false
    t.bigint "data_portion_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["data_portion_type", "data_portion_id"], name: "index_data_infos_on_data_portion_type_and_data_portion_id"
  end

  create_table "data_sets", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.jsonb "keys_info"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "dynamic_content1", force: :cascade do |t|
    t.jsonb "row"
  end

  create_table "dynamic_content2", force: :cascade do |t|
    t.jsonb "row"
  end

  create_table "dynamic_content3", force: :cascade do |t|
    t.jsonb "row"
  end

  create_table "jwt_blacklists", force: :cascade do |t|
    t.string "jti"
    t.datetime "exp"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["jti"], name: "index_jwt_blacklists_on_jti"
  end

  create_table "reports", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.jsonb "config_body"
    t.bigint "user_id", null: false
    t.bigint "data_set_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["data_set_id"], name: "index_reports_on_data_set_id"
    t.index ["user_id"], name: "index_reports_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "first_name"
    t.string "last_name"
    t.string "role"
    t.date "birthdate"
    t.integer "permission"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "reports", "data_sets"
  add_foreign_key "reports", "users"
end
