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

ActiveRecord::Schema.define(version: 2021_01_08_141715) do

  create_table "addresses", force: :cascade do |t|
    t.string "firstName"
    t.string "lastName"
    t.string "address1"
    t.string "address2"
    t.string "city"
    t.string "state"
    t.string "countryCode"
    t.string "postalCode"
    t.string "phone"
    t.integer "order_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "addressType", default: 0
    t.index ["order_id"], name: "index_addresses_on_order_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "name"
    t.string "lastUpdateTime"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "line_items", force: :cascade do |t|
    t.string "productId"
    t.string "productName"
    t.string "variantId"
    t.integer "quantity"
    t.integer "order_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "lineItemId"
    t.index ["order_id"], name: "index_line_items_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "orderId"
    t.string "orderNumber"
    t.string "customerEmail"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "customer_id", null: false
    t.string "fulfillmentStatus"
    t.index ["customer_id"], name: "index_orders_on_customer_id"
  end

  add_foreign_key "addresses", "orders"
  add_foreign_key "line_items", "orders"
  add_foreign_key "orders", "customers"
end
