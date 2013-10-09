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

ActiveRecord::Schema.define(version: 20131009160302) do

  create_table "events", force: true do |t|
    t.date     "date"
    t.string   "event_type"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "dinner_guest"
  end

  add_index "events", ["date"], name: "index_events_on_date"
  add_index "events", ["event_type"], name: "index_events_on_event_type"
  add_index "events", ["user_id", "date", "event_type", "dinner_guest"], name: "index_events_date_type_guest", unique: true
  add_index "events", ["user_id"], name: "index_events_on_user_id"

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
