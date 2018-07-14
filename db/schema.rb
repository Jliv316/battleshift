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

ActiveRecord::Schema.define(version: 20180712214942) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "boards", force: :cascade do |t|
    t.boolean "active"
    t.bigint "user_id"
    t.bigint "game_id"
    t.index ["game_id"], name: "index_boards_on_game_id"
    t.index ["user_id"], name: "index_boards_on_user_id"
  end

  create_table "games", force: :cascade do |t|
    t.integer "winner"
    t.integer "player_1_turns"
    t.integer "player_2_turns"
    t.string "current_turn", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "player_1_id"
    t.integer "player_2_id"
    t.string "player_1_api_key"
    t.string "player_2_api_key"
  end

  create_table "games_users", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "game_id"
    t.index ["game_id"], name: "index_games_users_on_game_id"
    t.index ["user_id"], name: "index_games_users_on_user_id"
  end

  create_table "ships", force: :cascade do |t|
    t.integer "damage"
    t.integer "length"
  end

  create_table "spaces", force: :cascade do |t|
    t.string "name"
    t.bigint "board_id"
    t.string "result", default: ""
    t.bigint "ship_id"
    t.index ["board_id"], name: "index_spaces_on_board_id"
    t.index ["ship_id"], name: "index_spaces_on_ship_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "first_name"
    t.string "last_name"
    t.string "api_key"
    t.string "password_digest"
    t.boolean "activated", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "boards", "games"
  add_foreign_key "boards", "users"
  add_foreign_key "games_users", "games"
  add_foreign_key "games_users", "users"
  add_foreign_key "spaces", "boards"
end
