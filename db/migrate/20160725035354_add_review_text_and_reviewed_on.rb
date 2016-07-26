class AddReviewTextAndReviewedOn < ActiveRecord::Migration[5.0]
  def change
    add_column :tweet_reviews, :text, :text
    add_column :tweet_reviews, :reviewed_at, :datetime
  end
end
