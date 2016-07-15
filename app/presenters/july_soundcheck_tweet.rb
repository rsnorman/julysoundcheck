class JulySoundcheckTweet
  attr_reader :tweet, :tweet_review, :reply_tweet

  delegate :profile_image_uri, :text, to: :tweet
  delegate :artist, :album, :listen_url, to: :tweet_review, allow_nil: true

  def initialize(tweet)
    @tweet = tweet
    @reply_tweet = tweet.reply
    @tweet_review = tweet.tweet_review || @reply_tweet.try(:tweet_review)
  end

  def user_name
    tweet.name
  end

  def screen_name
    tweet.screen_name
  end

  def tweeted_on
    tweet.tweeted_at.to_date
  end

  def tweet_status_id
    two_part? ? reply_tweet.id : tweet.id
  end

  def review_details?
    !tweet_review.try(:listen_url).blank? && !artist.blank? && !album.blank?
  end

  def two_part?
    !!reply_tweet
  end

  def review_text
    two_part? ? reply_tweet.text : text
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
