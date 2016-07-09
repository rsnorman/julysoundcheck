class JulySoundcheckTweet
  attr_reader :tweet, :tweet_review
  attr_accessor :review_tweet

  delegate :id, :in_reply_to_status_id, :user, :text, :created_at, to: :tweet
  delegate :listen_url, :artist, :album, to: :tweet_review, allow_nil: true

  def initialize(tweet, tweet_review)
    @tweet = tweet
    @tweet_review = tweet_review
  end

  def review_details?
    listen_url && artist && album
  end

  def review_tweet?
    review_tweet
  end

  def review_text
    review_tweet? ? review_tweet.text : text
  end

  def rating
    return tweet_review.rating if tweet_review
    /(?:(\d\s*[+|-]?\s*)?#julysoundcheck(\s*\d\s*[+|-]?)?)|(\d\s*[+|-]?)$/i.match(review_text) do |matches|
      matches.to_a.slice(1..-1).compact.first
    end
  end
end
