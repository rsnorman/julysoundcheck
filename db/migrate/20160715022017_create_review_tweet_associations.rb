class CreateReviewTweetAssociations < ActiveRecord::Migration[5.0]
  class MigrateTweetReview < ActiveRecord::Base
    self.table_name = :tweet_reviews
    belongs_to :tweet, class_name: 'MigrateTweet'
  end

  class MigrateTweet < ActiveRecord::Base
    self.table_name = :tweets
    has_one :in_reply_to_tweet, class_name: 'MigrateTweet'
  end

  def up
    rename_column :tweet_reviews, :tweet_id, :twitter_status_id
    add_column :tweet_reviews, :tweet_id, :integer
    add_column :tweets, :in_reply_to_tweet_id, :integer

    MigrateTweetReview.all.each do |tweet_review|
      tweet_review.update(
        tweet: MigrateTweet.find_by(tweet_id: tweet_review.twitter_status_id)
      )
    end

    MigrateTweet.where.not(in_reply_to_status_id: nil).each do |tweet|
      parent_tweet = MigrateTweet.find_by(tweet_id: tweet.in_reply_to_status_id)
      tweet.update(in_reply_to_tweet_id: parent_tweet.id) rescue nil
    end

    add_foreign_key :tweet_reviews, :tweets
    add_index :tweet_reviews, :tweet_id
    add_index :tweets, :in_reply_to_tweet_id
  end

  def down
    remove_column :tweet_reviews, :tweet_id
    remove_column :tweets, :in_reply_to_tweet_id
    rename_column :tweet_reviews, :twitter_status_id, :tweet_id
  end
end
