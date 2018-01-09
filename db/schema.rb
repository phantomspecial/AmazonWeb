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

ActiveRecord::Schema.define(version: 20180109084909) do

  create_table "carts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "quantity",     null: false
    t.integer  "stock_id"
    t.integer  "user_id"
    t.boolean  "buylater_flg", null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["stock_id"], name: "index_carts_on_stock_id", using: :btree
    t.index ["user_id"], name: "index_carts_on_user_id", using: :btree
  end

  create_table "categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",                      null: false
    t.text     "description", limit: 65535, null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["name"], name: "index_categories_on_name", unique: true, using: :btree
  end

  create_table "items", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "stock_id"
    t.string   "name",          null: false
    t.string   "image",         null: false
    t.string   "detail",        null: false
    t.string   "maker",         null: false
    t.integer  "unit_cost",     null: false
    t.integer  "quantity",      null: false
    t.integer  "sell_price",    null: false
    t.integer  "shipping_cost", null: false
    t.integer  "item_flg"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["stock_id"], name: "index_items_on_stock_id", using: :btree
  end

  create_table "orderdetails", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "order_id"
    t.integer  "stock_id"
    t.integer  "quantity"
    t.integer  "sell_price"
    t.integer  "shipping_cost"
    t.integer  "total_price"
    t.integer  "total_shippingcost"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "orders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.integer  "total"
    t.integer  "total_shippingcost"
    t.string   "payments"
    t.string   "status"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "stocks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",          null: false
    t.string   "image",         null: false
    t.string   "detail",        null: false
    t.string   "maker",         null: false
    t.integer  "avg_unit_cost", null: false
    t.integer  "current_stock", null: false
    t.integer  "sell_price",    null: false
    t.integer  "shipping_cost", null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "category_id"
  end

  create_table "sub_categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "category_id"
    t.string   "name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "first_name",                          null: false
    t.string   "last_name",                           null: false
    t.string   "nickname",                            null: false
    t.integer  "postal_code",                         null: false
    t.string   "pref",                                null: false
    t.string   "city",                                null: false
    t.string   "street",                              null: false
    t.string   "apartment_roomnumber"
    t.string   "telnumber",                           null: false
    t.boolean  "admin_flg"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "carts", "stocks"
  add_foreign_key "carts", "users"
  add_foreign_key "items", "stocks"
end
