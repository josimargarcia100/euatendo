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

ActiveRecord::Schema[8.1].define(version: 2026_02_26_191735) do
  create_table "attendances", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "ended_at"
    t.string "result"
    t.integer "seller_id", null: false
    t.datetime "started_at"
    t.integer "store_id", null: false
    t.datetime "updated_at", null: false
    t.index ["seller_id"], name: "index_attendances_on_seller_id"
    t.index ["store_id"], name: "index_attendances_on_store_id"
  end

  create_table "seller_queue_statuses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "position"
    t.integer "seller_id", null: false
    t.string "status"
    t.integer "store_id", null: false
    t.datetime "updated_at", null: false
    t.index ["seller_id"], name: "index_seller_queue_statuses_on_seller_id"
    t.index ["store_id"], name: "index_seller_queue_statuses_on_store_id"
  end

  create_table "stores", force: :cascade do |t|
    t.string "cnpj"
    t.datetime "created_at", null: false
    t.string "name"
    t.string "phone"
    t.string "timezone"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_stores_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name"
    t.string "phone"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.string "role"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "attendances", "sellers"
  add_foreign_key "attendances", "stores"
  add_foreign_key "seller_queue_statuses", "sellers"
  add_foreign_key "seller_queue_statuses", "stores"
  add_foreign_key "stores", "users"
end
