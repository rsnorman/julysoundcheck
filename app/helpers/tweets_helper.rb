module TweetsHelper
  def remove_hashtag_and_rating(tweet_text)
    tweet_text
      .strip
      .gsub(/(\d\s*[+|-]?\s*)?#julysoundcheck$/i, '')
      .gsub(/(\d\s*[+|-]?)$/, '')
  end

  def can_edit?(tweet)
    return false unless twitter_user
    return true if twitter_user.screen_name == ENV['ADMIN_TWITTER_SCREEN_NAME']
    tweet.screen_name == twitter_user.screen_name
  end

  def link_recommender(tweet_text)
    tweet_text.gsub(/@\w+/) do |screen_name|
      link_to screen_name, reviewer_path(screen_name.gsub('@', ''))
    end
  end

  def recent_tweets
    return [] unless current_user
    Tweet
      .where(user: current_user, in_reply_to_tweet_id: nil)
      .includes(:reply)
      .limit(3)
      .map do |tweet|
        JulySoundcheckTweet.new(tweet)
      end
  end
end
