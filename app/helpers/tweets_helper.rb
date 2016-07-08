module TweetsHelper
  def remove_hashtag_and_rating(tweet_text)
    tweet_text
      .strip
      .gsub(/(\d\s*[+|-]?\s*)?#julysoundcheck$/i, '')
      .gsub(/(\d\s*[+|-]?)$/, '')
  end

  def user_tweet?(tweet)
    return false unless twitter_user
    tweet.user.id == twitter_user.id
  end
end
