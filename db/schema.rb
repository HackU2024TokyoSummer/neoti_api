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

ActiveRecord::Schema[7.2].define(version: 2024_08_31_002910) do
  create_table "customers", force: :cascade do |t|
    t.string "customer_fincode_id"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_customers_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.string "jti"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "wakes", force: :cascade do |t|
    t.datetime "wake_time"
    t.boolean "neoti", default: false
    t.boolean "waked", default: false
    t.integer "user_id"
    t.integer "billing"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "access_id"
    t.string "order_id"
    t.index ["user_id"], name: "index_wakes_on_user_id"
  end

  add_foreign_key "customers", "users"
  add_foreign_key "wakes", "users"
end
