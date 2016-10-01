class JulySoundcheckTweet
  attr_reader :tweet, :reply_tweet, :user, :feed_item

  delegate :text, :id, to: :tweet
  delegate :profile_image_uri, to: :user

  def initialize(tweet, feed_item = nil)
    @tweet = tweet
    @reply_tweet = tweet.reply
    @user = @tweet.user
    @feed_item = feed_item
  end

  def user_name
    user.name.blank? ? user.twitter_name : user.name
  end

  def screen_name
    user.twitter_screen_name
  end

  def tweeted_on
    (feed_item ? feed_item.created_at : tweet.tweeted_at).in_time_zone.to_date
  end

  def tweet_status_id
    two_part? ? reply_tweet.id : tweet.id
  end

  def two_part?
    !!reply_tweet
  end

  def review_text
    two_part? ? reply_tweet.text : text
  end

  RATING_REGEX =
    /(?:(\d\s*[+|-]?\s*)?#julysoundcheck(\s*\d\s*[+|-]?)?)|(\d\s*[+|-]?)$/i

  def rating
    RATING_REGEX.match(review_text) do |matches|
      if (score = matches.to_a.slice(1..-1).compact.first)
        Rating.from_score(score.strip)
      end
    end
  end
end
