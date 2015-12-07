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

ActiveRecord::Schema.define(version: 20151207034235) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "aircrafts", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.string "country_id"
  end

  add_index "aircrafts", ["code"], name: "index_aircrafts_on_code", unique: true, using: :btree

  create_table "airlines", force: :cascade do |t|
    t.string "code"
    t.string "name"
  end

  add_index "airlines", ["code"], name: "index_airlines_on_code", unique: true, using: :btree

  create_table "airports", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.string "city_id"
  end

  add_index "airports", ["code"], name: "index_airports_on_code", unique: true, using: :btree

  create_table "bfsessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cities", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.string "country_id"
  end

  add_index "cities", ["code"], name: "index_cities_on_code", unique: true, using: :btree
  add_index "cities", ["name"], name: "index_cities_on_name", using: :btree

  create_table "countries", force: :cascade do |t|
    t.string  "code"
    t.string  "name"
    t.boolean "point_of_sale"
  end

  add_index "countries", ["code"], name: "index_countries_on_code", unique: true, using: :btree

  create_table "currencies", force: :cascade do |t|
    t.string "country"
    t.string "currency"
    t.string "code"
    t.string "symbol"
  end

  add_index "currencies", ["code"], name: "index_currencies_on_code", unique: true, using: :btree

  create_table "itins", force: :cascade do |t|
    t.text     "ticket_type"
    t.decimal  "price"
    t.text     "curr_code"
    t.integer  "bfsession_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "itins_legs", force: :cascade do |t|
    t.integer "itin_id"
    t.integer "leg_id"
  end

  add_index "itins_legs", ["itin_id"], name: "index_itins_legs_on_itin_id", using: :btree
  add_index "itins_legs", ["leg_id"], name: "index_itins_legs_on_leg_id", using: :btree

  create_table "legs", force: :cascade do |t|
    t.integer  "seq"
    t.text     "search_key"
    t.integer  "flight_mins"
    t.integer  "bfsession_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "legs", ["search_key"], name: "index_legs_on_search_key", unique: true, using: :btree

  create_table "segs", force: :cascade do |t|
    t.datetime "depart_datetime"
    t.datetime "arrive_datetime"
    t.integer  "stop_quantity"
    t.text     "flight_num"
    t.text     "depart_airport_code"
    t.text     "arrive_airport_code"
    t.integer  "flight_mins"
    t.text     "mark_airline_code"
    t.text     "op_airline_code"
    t.integer  "leg_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "taxes", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.string "country_id"
  end

  add_index "taxes", ["code"], name: "index_taxes_on_code", unique: true, using: :btree

end
