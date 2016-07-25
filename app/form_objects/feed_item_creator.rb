class FeedItemCreator
  attr_reader :feedable

  def initialize(feedable)
    @feedable = feedable
  end

  def create
    public_send("create_#{feedable.class.to_s.underscore}_feed_item")
  end

  def create_review_feed_item
    created_at = if feedable.created_at.to_date == feedable.reviewed_on
      feedable.created_at
    else
      feedable.reviewed_on
    end
    FeedItem.create(feedable: feedable,
                    created_at: created_at,
                    user: feedable.user)
  end

  def create_tweet_review_feed_item
    feed_item = FeedItem.find_by(feedable: feedable.tweet)
    feed_item ||= FeedItem.find_by(feedable: feedable.tweet.reply)
    feed_item.update(feedable: feedable)
  end

  def create_tweet_feed_item
    if feedable.reply?
      FeedItem
        .find_by(feedable: feedable.in_reply_to_tweet)
        .update(created_at: feedable.tweeted_at)
    else
      FeedItem.create(feedable: feedable,
                      created_at: feedable.tweeted_at,
                      user: feedable.user)
    end
  end
end
