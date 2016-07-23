class AddReviewTextToTweetReview < ActiveRecord::Migration[5.0]
  def change
    add_column :tweet_reviews, :text, :text
  end
end
