class JulySoundcheckTweets
  def self.all
    new.all
  end

  def initialize(tweets = Tweet.all)
    @tweets = tweets
  end

  def all
    @tweets
      .where(in_reply_to_tweet: nil)
      .includes(:tweet_review, :reply)
      .order(tweeted_at: :desc)
  end
end
