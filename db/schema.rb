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

ActiveRecord::Schema.define(version: 20170710110046) do

  create_table "auth_tokens", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.bigint "user_id", null: false
    t.string "token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "fk_rails_0d66c22f4c"
  end

  create_table "communication_preferences", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.bigint "user_id", null: false
    t.boolean "email_on_new_discussion_post", default: true, null: false
    t.boolean "email_on_new_discussion_post_for_mentor", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "fk_rails_65642a5510"
  end

  create_table "discussion_posts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.bigint "iteration_id", null: false
    t.bigint "user_id", null: false
    t.text "content", limit: 4294967295, null: false
    t.text "html", limit: 4294967295, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["iteration_id"], name: "fk_rails_f58a02b68e"
  end

  create_table "exercises", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.bigint "track_id", null: false
    t.bigint "unlocked_by_id"
    t.string "uuid", null: false
    t.string "slug", null: false
    t.string "title", null: false
    t.boolean "core", default: false, null: false
    t.boolean "active", default: false, null: false
    t.integer "difficulty", default: 1, null: false
    t.integer "length", default: 1, null: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["track_id"], name: "fk_rails_a796d89c21"
    t.index ["unlocked_by_id"], name: "fk_rails_03ec4ffbf3"
  end

  create_table "favourites", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.bigint "iteration_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["iteration_id"], name: "fk_rails_6ae4b0efef"
  end

  create_table "iterations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.bigint "solution_id", null: false
    t.text "code", limit: 4294967295, null: false
    t.integer "mentor_status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["solution_id"], name: "fk_rails_5d9f1bf4bd"
  end

  create_table "mentor_reviews", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.bigint "user_id", null: false
    t.bigint "mentor_id", null: false
    t.bigint "solution_id", null: false
    t.integer "rating", null: false
    t.text "feedback"
    t.boolean "show_to_mentor", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mentor_id"], name: "fk_rails_fd0b77fa40"
    t.index ["solution_id"], name: "fk_rails_d073b02ecc"
    t.index ["user_id"], name: "fk_rails_311ec25a41"
  end

  create_table "mentored_tracks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.bigint "user_id"
    t.bigint "track_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["track_id"], name: "fk_rails_610977bb5c"
    t.index ["user_id"], name: "fk_rails_a8c6a413eb"
  end

  create_table "notifications", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.bigint "user_id"
    t.string "about_type"
    t.bigint "about_id"
    t.string "type"
    t.text "content"
    t.text "link"
    t.boolean "read", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "fk_rails_b080fb4855"
  end

  create_table "profiles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.bigint "user_id", null: false
    t.string "slug", null: false
    t.string "name", null: false
    t.text "bio"
    t.string "twitter"
    t.string "website"
    t.string "github"
    t.string "linkedin"
    t.string "medium"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_profiles_on_slug", unique: true
    t.index ["user_id"], name: "fk_rails_e424190865"
  end

  create_table "solutions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.bigint "user_id", null: false
    t.bigint "exercise_id", null: false
    t.string "git_sha", null: false
    t.bigint "approved_by_id"
    t.datetime "cloned_at"
    t.datetime "completed_at"
    t.datetime "published_at"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approved_by_id"], name: "fk_rails_4cc89d0b11"
    t.index ["exercise_id"], name: "fk_rails_8c0841e614"
    t.index ["user_id"], name: "fk_rails_f83c42cef4"
  end

  create_table "tracks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "slug", null: false
    t.string "title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_tracks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.bigint "user_id", null: false
    t.bigint "track_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["track_id"], name: "fk_rails_631b3d694d"
    t.index ["user_id"], name: "fk_rails_99e944edbc"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "name", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "provider"
    t.string "uid"
    t.boolean "admin", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "auth_tokens", "users"
  add_foreign_key "communication_preferences", "users"
  add_foreign_key "discussion_posts", "iterations"
  add_foreign_key "exercises", "exercises", column: "unlocked_by_id"
  add_foreign_key "exercises", "tracks"
  add_foreign_key "favourites", "iterations"
  add_foreign_key "iterations", "solutions"
  add_foreign_key "mentor_reviews", "solutions"
  add_foreign_key "mentor_reviews", "users"
  add_foreign_key "mentor_reviews", "users", column: "mentor_id"
  add_foreign_key "mentored_tracks", "tracks"
  add_foreign_key "mentored_tracks", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "profiles", "users"
  add_foreign_key "solutions", "exercises"
  add_foreign_key "solutions", "users"
  add_foreign_key "solutions", "users", column: "approved_by_id"
  add_foreign_key "user_tracks", "tracks"
  add_foreign_key "user_tracks", "users"
end
