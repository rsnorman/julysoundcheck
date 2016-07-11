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

  def link_recommender(tweet_text)
    tweet_text.gsub(/@\w+/) do |screen_name|
      link_to screen_name, reviewer_path(screen_name.gsub('@', ''))
    end
  end
end
