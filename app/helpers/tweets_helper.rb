module TweetsHelper
  def remove_hashtag_and_rating(tweet_text)
    tweet_text
      .strip
      .gsub(/(\d\s*[+|-]?\s*)?#julysoundcheck$/i, '')
      .gsub(/(\d\s*[+|-]?)$/, '')
  end
end
