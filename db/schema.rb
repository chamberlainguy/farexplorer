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

ActiveRecord::Schema.define(version: 20151109233300) do

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

  create_table "taxes", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.string "country_id"
  end

  add_index "taxes", ["code"], name: "index_taxes_on_code", unique: true, using: :btree

end
