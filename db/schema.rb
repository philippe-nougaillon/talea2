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

ActiveRecord::Schema[7.1].define(version: 2024_04_19_085019) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "interventions", force: :cascade do |t|
    t.datetime "début"
    t.datetime "fin"
    t.integer "temps_de_pause"
    t.string "description"
    t.string "workflow_state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "organisation_id", null: false
    t.integer "agent_id"
    t.integer "agent_binome_id"
    t.integer "adherent_id"
    t.index ["adherent_id"], name: "index_interventions_on_adherent_id"
    t.index ["agent_binome_id"], name: "index_interventions_on_agent_binome_id"
    t.index ["agent_id"], name: "index_interventions_on_agent_id"
    t.index ["organisation_id"], name: "index_interventions_on_organisation_id"
  end

  create_table "organisations", force: :cascade do |t|
    t.string "nom"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "organisation_id"
    t.string "nom"
    t.string "prénom"
    t.integer "rôle", default: 0, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["organisation_id"], name: "index_users_on_organisation_id"
  end

  add_foreign_key "interventions", "organisations"
  add_foreign_key "users", "organisations"
end
