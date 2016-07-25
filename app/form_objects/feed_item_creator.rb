class FeedItemCreator
  attr_reader :feedable

  def initialize(feedable)
    @feedable = feedable
  end

  def create
    public_send("create_#{feedable.class.to_s.underscore}_feed_item")
  end

  def create_tweet_review_feed_item
    FeedItem.find_by(feedable: feedable.tweet).update(feedable: feedable)
  end

  def create_tweet_feed_item
    if feedable.reply?
      FeedItem
        .find_by(feedable: feedable.in_reply_to_tweet)
        .update(created_at: feedable.tweeted_at)
    else
      FeedItem.create(feedable: feedable, created_at: feedable.tweeted_at)
    end
  end
end
