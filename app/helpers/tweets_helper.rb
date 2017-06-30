module TweetsHelper
  def remove_hashtag_and_rating(tweet_text)
    tweet_text
      .strip
      .gsub(/(\d\s*[+|-]?\s*)?#julysoundcheck$/i, '')
      .gsub(/(\d\s*[+|-]?)$/, '')
      .strip
  end

  def can_edit?(tweet)
    return true if is_admin_user?
    if twitter_user
      tweet.screen_name == twitter_user.screen_name
    elsif current_user
      tweet.user.id == current_user.id
    else
      false
    end
  end

  def is_admin_user?
    if twitter_user
      is_admin_screen_name?(twitter_user.screen_name)
    elsif current_user
      is_admin_email?(current_user.email)
    end
  end

  def link_recommender(tweet_text)
    tweet_text.gsub(/@\w+/) do |screen_name|
      link_to(screen_name,
              reviewer_path(screen_name.delete('@')),
              class: 'recommender')
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

  private

  def is_admin_screen_name?(screen_name)
    screen_name == ENV['ADMIN_TWITTER_SCREEN_NAME'] ||
      screen_name == ENV['TEST_ADMIN_TWITTER_SCREEN_NAME']
  end

  def is_admin_email?(email)
    puts [email, ENV['ADMIN_EMAIL'], ENV['TEST_ADMIN_EMAIL']].inspect
    email == ENV['ADMIN_EMAIL'] || email == ENV['TEST_ADMIN_EMAIL']
  end
end
