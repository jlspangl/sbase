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

ActiveRecord::Schema.define(:version => 20130602223858) do

  create_table "calibrations", :force => true do |t|
    t.string   "orig_filename"
    t.string   "measurement_unit"
    t.date     "caldate"
    t.date     "expdate"
    t.float    "calibration_max",  :default => 0.0
    t.float    "calibration_min",  :default => 0.0
    t.float    "range",            :default => 0.0
    t.boolean  "dirty",            :default => true
    t.string   "folder"
    t.string   "string"
    t.integer  "mode"
    t.integer  "integer"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
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

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "sensors", :force => true do |t|
    t.string   "name"
    t.string   "category"
    t.string   "ecn"
    t.string   "mcn"
    t.string   "model"
    t.string   "serial"
    t.string   "tag"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sensors", ["ecn"], :name => "index_sensors_on_ecn"
  add_index "sensors", ["mcn"], :name => "index_sensors_on_mcn"
  add_index "sensors", ["serial"], :name => "index_sensors_on_serial"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id"

end
