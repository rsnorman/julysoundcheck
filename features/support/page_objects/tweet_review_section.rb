require_relative 'album_details_section'
require_relative 'album_player_section'
require './app/helpers/tweets_helper'

class TweetReviewSection < SitePrism::Section
  include TweetsHelper

  element :user_name, '.user-name'
  element :twitter_user_name, '.twitter-username a'
  element :reviewed_on, '.reviewed-on'
  element :rating, '.review-rating'
  element :review_text, '.tweet-text'
  element :reply_text, '.tweet-reply'
  element :aotm_badge, '.album-of-the-month'
  section :album_details, AlbumDetailsSection, '.genre'
  section :album_player, AlbumPlayerSection, '.listen-embed'

  def reviewed_on?(datetime)
    reviewed_on.has_content? datetime.to_date.to_formatted_s(:long_ordinal)
  end

  def has_profile_link_to?(user)
    twitter_user_name[:href].end_with? "/reviewers/#{user.twitter_screen_name}/feed"
  end

  def has_review_text?(tweet_review)
    review_text.has_content? remove_hashtag_and_rating(tweet_review.tweet.text)
  end

  def has_reply_text?(tweet_review)
    reply_text.has_content? remove_hashtag_and_rating(tweet_review.tweet.reply.text)
  end

  def edit_review
    click_link 'Edit review details'
    EditReview.new
  end
end
