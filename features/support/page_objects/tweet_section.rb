require './app/helpers/tweets_helper'

class TweetSection < SitePrism::Section
  include TweetsHelper

  element :user_name, '.user-name'
  element :twitter_user_name, '.twitter-username a'
  element :tweeted_on, '.reviewed-on'
  element :rating, '.review-rating'
  element :review_text, '.tweet-text'
  element :reply_text, '.tweet-reply'
  element :recommender, '.recommender'

  def tweeted_on?(datetime)
    tweeted_on.has_content? datetime.to_date.to_formatted_s(:long_ordinal)
  end

  def has_profile_link_to?(user)
    twitter_user_name[:href].end_with? "/reviewers/#{user.twitter_screen_name}/feed"
  end

  def has_tweet_text?(tweet)
    review_text.has_content? remove_hashtag_and_rating(tweet.text)
  end

  def has_reply_text?(tweet)
    reply_text.has_content? remove_hashtag_and_rating(tweet.reply.text)
  end

  def create_review
    click_link 'Add review details'
    NewReview.new
  end
end
