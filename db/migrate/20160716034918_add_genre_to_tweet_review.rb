class AddGenreToTweetReview < ActiveRecord::Migration[5.0]
  def change
    add_column :tweet_reviews, :genre, :string
  end
end
