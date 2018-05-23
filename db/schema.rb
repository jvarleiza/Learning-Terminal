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

ActiveRecord::Schema.define(version: 20180205074709) do

  create_table "bookmarks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "user"
    t.string   "roles"
    t.string   "processes"
    t.string   "tasks"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "process_lts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.text     "description",         limit: 16777215
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.text     "content",             limit: 4294967295
    t.text     "related_links",       limit: 16777215
    t.text     "related_attachments", limit: 16777215
    t.string   "locale"
    t.string   "departments"
    t.string   "countries"
    t.string   "building_types"
    t.boolean  "inactive"
    t.string   "embeded_video"
    t.string   "origin"
    t.boolean  "restricted"
  end

  create_table "process_lts_roles", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer "process_lt_id"
    t.integer "role_id"
    t.index ["process_lt_id"], name: "index_process_lts_roles_on_process_lts_id", using: :btree
    t.index ["role_id"], name: "index_process_lts_roles_on_role_id", using: :btree
  end

  create_table "process_lts_tasks", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer "task_id"
    t.integer "process_lt_id"
    t.index ["process_lt_id"], name: "index_process_lts_tasks_on_process_lt_id", using: :btree
    t.index ["task_id"], name: "index_process_lts_tasks_on_task_id", using: :btree
  end

  create_table "quality_tips", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.text     "description",    limit: 16777215
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "locale"
    t.string   "departments"
    t.string   "countries"
    t.string   "building_types"
    t.boolean  "inactive"
  end

  create_table "related_processes", primary_key: ["process_lt_a_id", "process_lt_b_id"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer "process_lt_a_id", null: false
    t.integer "process_lt_b_id", null: false
  end

  create_table "related_roles", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer "role_a_id"
    t.integer "role_b_id"
  end

  create_table "related_tasks", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer "task_a_id"
    t.integer "task_b_id"
  end

  create_table "roles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.text     "description",         limit: 4294967295
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "locale"
    t.string   "departments"
    t.string   "countries"
    t.string   "building_types"
    t.string   "related_links"
    t.string   "related_attachments"
    t.boolean  "inactive"
    t.string   "origin"
    t.boolean  "restricted"
  end

  create_table "roles_tasks", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer "role_id"
    t.integer "task_id"
    t.index ["role_id"], name: "index_roles_tasks_on_role_id", using: :btree
    t.index ["task_id"], name: "index_roles_tasks_on_task_id", using: :btree
  end

  create_table "tasks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "start"
    t.datetime "end"
    t.string   "name"
    t.text     "description",         limit: 16777215
    t.integer  "task_type"
    t.string   "color"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "locale"
    t.string   "departments"
    t.string   "countries"
    t.string   "building_types"
    t.string   "related_links"
    t.string   "related_attachments"
    t.boolean  "inactive"
    t.integer  "day_of_week"
    t.integer  "hour_start"
    t.integer  "min_start"
    t.integer  "duration"
    t.boolean  "mark_start"
    t.string   "origin"
    t.boolean  "restricted"
  end

  add_foreign_key "process_lts_roles", "process_lts"
  add_foreign_key "process_lts_roles", "roles"
  add_foreign_key "process_lts_tasks", "process_lts"
  add_foreign_key "process_lts_tasks", "tasks"
  add_foreign_key "roles_tasks", "roles"
  add_foreign_key "roles_tasks", "tasks"
end
