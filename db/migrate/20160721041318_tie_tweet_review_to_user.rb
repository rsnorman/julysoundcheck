class TieTweetReviewToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :tweet_reviews, :user_id, :integer
    add_column :tweets, :user_id, :integer
  end
end
