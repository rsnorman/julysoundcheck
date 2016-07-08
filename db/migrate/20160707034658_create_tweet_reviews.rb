class CreateTweetReviews < ActiveRecord::Migration[5.0]
  def change
    create_table :tweet_reviews do |t|
      t.string :tweet_id
      t.integer :rating

      t.timestamps
    end
  end
end
