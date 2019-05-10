# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_05_10_210728) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clients", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "csv_table_fifties", force: :cascade do |t|
    t.bigint "project_id"
    t.integer "total_lines"
    t.jsonb "csv_content", default: "[]", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_csv_table_fifties_on_project_id"
  end

  create_table "csv_table_forties", force: :cascade do |t|
    t.bigint "project_id"
    t.integer "total_lines"
    t.jsonb "csv_content", default: "[]", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_csv_table_forties_on_project_id"
  end

  create_table "csv_table_tens", force: :cascade do |t|
    t.bigint "project_id"
    t.integer "total_lines"
    t.jsonb "csv_content", default: "[]", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_csv_table_tens_on_project_id"
  end

  create_table "csv_table_thirties", force: :cascade do |t|
    t.bigint "project_id"
    t.integer "total_lines"
    t.jsonb "csv_content", default: "[]", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_csv_table_thirties_on_project_id"
  end

  create_table "csv_table_twenties", force: :cascade do |t|
    t.bigint "project_id"
    t.integer "total_lines"
    t.jsonb "csv_content", default: "[]", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_csv_table_twenties_on_project_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name", null: false
    t.text "description", null: false
    t.bigint "client_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_projects_on_client_id"
  end

  add_foreign_key "csv_table_fifties", "projects"
  add_foreign_key "csv_table_forties", "projects"
  add_foreign_key "csv_table_tens", "projects"
  add_foreign_key "csv_table_thirties", "projects"
  add_foreign_key "csv_table_twenties", "projects"
  add_foreign_key "projects", "clients"
end
