class FeedItemCreator
  attr_reader :feedable

  def initialize(feedable, type = nil)
    @feedable = feedable
    @type = type || feedable.class.to_s.underscore
  end

  def create
    send("create_#{@type}_feed_item")
  end

  private

  def create_review_feed_item
    FeedItem.create(feedable: feedable,
                    created_at: feedable.reviewed_at,
                    user: feedable.user)
  end

  def create_tweet_review_feed_item
    feed_item = FeedItem.find_by(feedable: feedable.tweet)
    feed_item ||= FeedItem.find_by(feedable: feedable.tweet.reply)
    if feed_item
      feed_item.update(feedable: feedable)
    else
      tweet = feedable.tweet.reply || feedable.tweet
      FeedItem.create(feedable: feedable,
                      created_at: tweet.tweeted_at,
                      user: feedable.user)
    end
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
