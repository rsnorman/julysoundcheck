class JulySoundcheckTweetReview
  attr_reader :tweet, :tweet_review, :reply_tweet, :user, :feed_item

  delegate :text, :id, to: :tweet
  delegate :profile_image_uri, to: :user
  delegate :rating, :artist, :album, :listen_url, :genre, to: :tweet_review
  delegate :description, to: :rating, prefix: true

  def initialize(tweet_review, feed_item)
    @tweet = tweet_review.tweet
    @reply_tweet = tweet.reply
    @tweet_review = tweet_review
    @user = @tweet_review.user
    @feed_item = feed_item
  end

  def user_name
    user.name.blank? ? user.twitter_name : user.name
  end

  def screen_name
    user.twitter_screen_name
  end

  def reviewed_on
    feed_item.created_at.to_date
  end

  def tweet_status_id
    two_part? ? reply_tweet.id : tweet.id
  end

  def review_details?
    !tweet_review.listen_url.blank? && !artist.blank? && !album.blank?
  end

  def two_part?
    !!reply_tweet
  end

  def review_text
    two_part? ? reply_tweet.text : text
  end

  def listen_source
    return if tweet_review.listen_url.blank?
    tweet_review.listen_source
  end

  def album_id
    tweet_review.album_source_id
  end
end
