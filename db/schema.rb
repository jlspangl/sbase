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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130311183358) do

  create_table "calibrations", :force => true do |t|
    t.string   "filename"
    t.date     "cal_date"
    t.date     "expiration_date"
    t.float    "range_max",       :default => 0.0
    t.float    "range_min",       :default => 0.0
    t.integer  "sensor_id"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "calibrations", ["sensor_id", "cal_date"], :name => "index_calibrations_on_sensor_id_and_cal_date"

  create_table "sensors", :force => true do |t|
    t.string   "name"
    t.string   "category"
    t.string   "ecn"
    t.string   "mcn"
    t.string   "model"
    t.integer  "serial_no"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sensors", ["ecn"], :name => "index_sensors_on_ecn"
  add_index "sensors", ["mcn"], :name => "index_sensors_on_mcn"
  add_index "sensors", ["serial_no"], :name => "index_sensors_on_serial_no"

  create_table "users", :force => true do |t|
    t.string   "email"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",           :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
