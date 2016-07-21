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

ActiveRecord::Schema.define(version: 20160721025604) do

  create_table "tweet_reviews", force: :cascade do |t|
    t.string   "twitter_status_id"
    t.integer  "rating"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "artist"
    t.string   "album"
    t.string   "listen_url"
    t.string   "album_source_id"
    t.integer  "tweet_id"
    t.string   "genre"
    t.index ["tweet_id"], name: "index_tweet_reviews_on_tweet_id"
  end

  create_table "tweets", force: :cascade do |t|
    t.string   "tweet_id",                              null: false
    t.string   "screen_name",                           null: false
    t.string   "name",                                  null: false
    t.text     "text",                                  null: false
    t.boolean  "is_review",             default: false, null: false
    t.datetime "tweeted_at",                            null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "in_reply_to_status_id"
    t.string   "profile_image_uri"
    t.integer  "in_reply_to_tweet_id"
    t.index ["in_reply_to_tweet_id"], name: "index_tweets_on_in_reply_to_tweet_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "twitter_id"
    t.string   "twitter_name"
    t.string   "twitter_screen_name"
    t.boolean  "admin",               default: false
    t.datetime "last_sign_in"
    t.integer  "sign_ins",            default: 0
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

end
