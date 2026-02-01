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

ActiveRecord::Schema[8.0].define(version: 2026_02_01_183001) do
  create_table "jwt_denylists", id: { type: :string, limit: 36 }, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "jti", null: false
    t.datetime "exp", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["jti"], name: "index_jwt_denylists_on_jti", unique: true
  end

  create_table "promo_reports", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "promo_id", null: false
    t.string "user_id", limit: 36, null: false
    t.string "reason", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["promo_id", "user_id"], name: "index_promo_reports_on_promo_id_and_user_id", unique: true
    t.index ["promo_id"], name: "index_promo_reports_on_promo_id"
    t.index ["user_id"], name: "fk_rails_9794bd91f6"
  end

  create_table "promos", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "user_id", limit: 36, null: false
    t.string "store_id", limit: 36, null: false
    t.string "title", limit: 200, null: false
    t.text "description"
    t.decimal "original_price", precision: 10, scale: 2, null: false
    t.decimal "promo_price", precision: 10, scale: 2, null: false
    t.integer "promo_type", null: false
    t.string "link"
    t.string "full_address"
    t.float "latitude"
    t.float "longitude"
    t.datetime "expires_at"
    t.boolean "is_verified", default: false, null: false
    t.string "product_brand", null: false
    t.string "product_size", null: false
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_promos_on_created_at"
    t.index ["expires_at"], name: "index_promos_on_expires_at"
    t.index ["link"], name: "index_promos_on_link", unique: true
    t.index ["product_brand"], name: "index_promos_on_product_brand"
    t.index ["product_size"], name: "index_promos_on_product_size"
    t.index ["promo_type"], name: "index_promos_on_promo_type"
    t.index ["store_id"], name: "index_promos_on_store_id"
    t.index ["user_id"], name: "index_promos_on_user_id"
  end

  create_table "stores", id: { type: :string, limit: 36 }, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.float "latitude"
    t.float "longitude"
    t.boolean "is_online"
    t.string "website_url"
    t.integer "promos_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_stores_on_name"
  end

  create_table "users", id: { type: :string, limit: 36 }, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "promo_reports", "promos"
  add_foreign_key "promo_reports", "users"
  add_foreign_key "promos", "stores"
  add_foreign_key "promos", "users"
end
