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

ActiveRecord::Schema.define(:version => 20130317233718) do

  create_table "calibrations", :force => true do |t|
    t.string   "orig_filename"
    t.string   "measurement_unit"
    t.date     "calibration_date"
    t.date     "expiration_date"
    t.float    "calibration_max",  :default => 0.0
    t.float    "calibration_min",  :default => 0.0
    t.float    "range",            :default => 0.0
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.string   "folder"
  end

  create_table "measurements", :force => true do |t|
    t.integer  "sensor_id"
    t.integer  "calibration_id"
    t.integer  "position"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "measurements", ["calibration_id"], :name => "index_measurements_on_calibration_id"
  add_index "measurements", ["sensor_id", "calibration_id"], :name => "index_measurements_on_sensor_id_and_calibration_id", :unique => true
  add_index "measurements", ["sensor_id"], :name => "index_measurements_on_sensor_id"

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
