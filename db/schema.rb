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

ActiveRecord::Schema.define(version: 2019_03_13_034554) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "githubs", force: :cascade do |t|
    t.string "login"
    t.string "node_id"
    t.string "avatar_url"
    t.string "gravatar_id"
    t.string "html_url"
    t.boolean "site_admin"
    t.string "name"
    t.string "company"
    t.string "blog"
    t.string "location"
    t.string "email"
    t.string "hireable"
    t.string "bio"
    t.integer "public_repos"
    t.integer "public_gists"
    t.integer "followers"
    t.integer "following"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_githubs_on_user_id"
  end

  create_table "repos", force: :cascade do |t|
    t.string "node_id"
    t.string "name"
    t.string "full_name"
    t.string "html_url"
    t.string "description"
    t.bigint "github_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["github_id"], name: "index_repos_on_github_id"
  end

  create_table "users", force: :cascade do |t|
    t.boolean "is_bot"
    t.string "first_name"
    t.string "last_name"
    t.string "username"
    t.string "language_code"
    t.string "github_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "githubs", "users"
  add_foreign_key "repos", "githubs"
end
