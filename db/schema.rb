# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160323094633) do

  create_table "contracts", force: :cascade do |t|
    t.integer  "leaf_id"
    t.date     "contract_date",  null: false
    t.date     "start_month",    null: false
    t.integer  "term1",          null: false
    t.integer  "money1",         null: false
    t.integer  "term2",          null: false
    t.integer  "money2",         null: false
    t.boolean  "new_flag",       null: false
    t.boolean  "skip_flag",      null: false
    t.string   "staff_nickname", null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "contracts", ["leaf_id"], name: "index_contracts_on_leaf_id"

  create_table "customers", force: :cascade do |t|
    t.integer  "leaf_id"
    t.string   "first_name",   limit: 10,                 null: false
    t.string   "last_name",    limit: 10,                 null: false
    t.string   "first_read",   limit: 20,                 null: false
    t.string   "last_read",    limit: 20,                 null: false
    t.boolean  "sex",                                     null: false
    t.string   "address",      limit: 50,                 null: false
    t.string   "phone_number", limit: 12
    t.string   "cell_number",  limit: 13
    t.string   "receipt",      limit: 50,  default: "不要", null: false
    t.string   "comment",      limit: 100
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_index "customers", ["leaf_id"], name: "index_customers_on_leaf_id"

  create_table "leafs", force: :cascade do |t|
    t.integer  "number",          limit: 4, null: false
    t.integer  "vhiecle_type",    limit: 1, null: false
    t.boolean  "student_flag",              null: false
    t.boolean  "largebike_flag",            null: false
    t.boolean  "valid_flag",                null: false
    t.date     "start_date",                null: false
    t.date     "last_date"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "contracts_count"
  end

  add_index "leafs", ["number", "vhiecle_type", "valid_flag"], name: "index_leafs_on_number_and_vhiecle_type_and_valid_flag"

  create_table "seals", force: :cascade do |t|
    t.integer  "contract_id"
    t.date     "month",          null: false
    t.boolean  "sealed_flag",    null: false
    t.date     "sealed_date"
    t.string   "staff_nickname"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "seals", ["contract_id"], name: "index_seals_on_contract_id"

  create_table "staffdetails", force: :cascade do |t|
    t.integer  "staff_id"
    t.string   "name",         limit: 20, null: false
    t.string   "read",         limit: 20, null: false
    t.string   "address",      limit: 50, null: false
    t.date     "birthday",                null: false
    t.string   "phone_number", limit: 12
    t.string   "cell_number",  limit: 13
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "staffdetails", ["staff_id"], name: "index_staffdetails_on_staff_id"

  create_table "staffs", force: :cascade do |t|
    t.string   "nickname",   limit: 10,                 null: false
    t.string   "password",                              null: false
    t.boolean  "admin_flag",            default: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "salt",       limit: 20, default: "0",   null: false
  end

  add_index "staffs", ["nickname"], name: "index_staffs_on_nickname"

end
