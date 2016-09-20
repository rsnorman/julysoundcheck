require './app/helpers/tweets_helper'

class RecentTweetsSection < SitePrism::Section
  include TweetsHelper

  def has_tweet?(tweet)
    has_content?(remove_hashtag_and_rating(tweet.text))
  end
end
