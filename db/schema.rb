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

ActiveRecord::Schema.define(version: 2021_09_07_055543) do

  create_table "favorites", force: :cascade do |t|
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lists", force: :cascade do |t|
    t.string "word"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "meaning"
    t.integer "user_id"
  end

  create_table "partofspeeches", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.string "path"
  end

  create_table "results", force: :cascade do |t|
    t.string "answer"
    t.string "solution"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.string "q_word"
    t.integer "q_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
  end

  create_table "words", force: :cascade do |t|
    t.string "word"
    t.string "meaning"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.datetime "deleted_at"
    t.string "part_of_speech"
    t.boolean "favorite", default: false, null: false
    t.integer "wrong_number", default: 0
    t.integer "count", default: 0
    t.integer "favorite_count", default: 0
    t.integer "forgot_count", default: 0
    t.index ["deleted_at"], name: "index_words_on_deleted_at"
  end

end
