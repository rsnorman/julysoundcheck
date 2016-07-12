class JulySoundcheckTweet
  attr_reader :tweet, :tweet_review
  attr_accessor :review_tweet

  delegate :in_reply_to_status_id, :user, :text, :created_at, to: :tweet
  delegate :artist, :album, :listen_url, to: :tweet_review, allow_nil: true

  def initialize(tweet, tweet_review)
    @tweet = tweet
    @tweet_review = tweet_review
  end

  def tweet_id
    review_tweet? ? review_tweet.id : tweet.id
  end

  def review_details?
    !tweet_review.try(:listen_url).blank? && !artist.blank? && !album.blank?
  end

  def review_tweet?
    review_tweet
  end

  def review_text
    review_tweet? ? review_tweet.text : text
  end

  def listen_source
    return if tweet_review.nil? || tweet_review.listen_source.try(:url).blank?
    tweet_review.listen_source
  end

  def album_id
    tweet_review.album_source_id || listen_source.try(:album_id)
  end

  def rating
    return tweet_review.rating if tweet_review && !tweet_review.rating.to_s.blank?
    /(?:(\d\s*[+|-]?\s*)?#julysoundcheck(\s*\d\s*[+|-]?)?)|(\d\s*[+|-]?)$/i.match(review_text) do |matches|
      matches.to_a.slice(1..-1).compact.first
    end
  end
end
