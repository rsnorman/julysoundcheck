class CreateFeedItems < ActiveRecord::Migration[5.0]
  class MigrateFeedItem < ActiveRecord::Base
    self.table_name = :feed_items
    belongs_to :feedable, polymorphic: true
  end

  class MigrateTweetReview < ActiveRecord::Base
    self.table_name = :tweet_reviews
  end

  class MigrateTweet < ActiveRecord::Base
    self.table_name = :tweets
    has_one :tweet_review, foreign_key: :tweet_id, class_name: 'MigrateTweetReview'
    has_one :reply, foreign_key: :in_reply_to_tweet_id, class_name: 'MigrateTweet'
  end

  def up
    create_table :feed_items do |t|
      t.references :feedable, polymorphic: true, index: true
      t.timestamps
    end

    MigrateTweet
      .where(in_reply_to_tweet_id: nil)
      .includes(:tweet_review, :reply).each do |tweet|
        if tweet.tweet_review
          MigrateFeedItem.create(feedable_type: 'TweetReview',
                                 feedable_id: tweet.tweet_review.id,
                                 created_at: tweet.reply.try(:tweeted_at) || tweet.tweeted_at)
        else
          MigrateFeedItem.create(feedable_type: 'Tweet',
                                 feedable_id: tweet.id,
                                 created_at: tweet.tweeted_at)
        end
      end
  end

  def down
    drop_table :feed_items
  end
end
