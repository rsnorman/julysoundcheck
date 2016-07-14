class Tweets < ActiveRecord::Migration[5.0]
  def change
    create_table :tweets do |t|
      t.string  :tweet_id,                null: false
      t.string   :screen_name,            null: false
      t.string   :name,                   null: false
      t.string   :in_reply_to_status_id,  null: false
      t.string   :profile_image_uri,      null: false
      t.text     :text,                   null: false
      t.boolean  :is_review,              null: false, default: false
      t.datetime :tweeted_at,             null: false

      t.timestamps
    end
  end
end
