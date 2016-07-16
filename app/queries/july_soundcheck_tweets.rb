class JulySoundcheckTweets
  def self.all
    new.all
  end

  def initialize(tweets = Tweet.all)
    @tweets = tweets
      .where(in_reply_to_tweet: nil)
      .includes(:tweet_review, :reply)
  end

  def rated(rating)
    return self if rating.blank?

    @tweets = @tweets
      .where(tweet_reviews: {rating: Rating.values_from_score(rating)})
      .unscope(:order)
      .order('tweet_reviews.rating DESC')
    self
  end

  def all
    @tweets
  end
end
