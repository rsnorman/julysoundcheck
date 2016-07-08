class TweetsController < ApplicationController
  before_action :set_tweet_reviews, only: :index
  before_action :set_tweets, only: :index

  cattr_accessor :tweets

  private

  def set_tweet_reviews
    @tweet_reviews = TweetReview.all.inject({}) do |tweet_reviews, tweet_review|
      tweet_reviews.merge(tweet_review.tweet_id.to_i => tweet_review)
    end
  end

  def set_tweets
    tweets = {}
    july_soundcheck_tweets.each do |tweet|
      if tweets[tweet.in_reply_to_status_id]
        tweets[tweet.in_reply_to_status_id].review_tweet = tweet
      else
        tweets[tweet.id] = JulySoundcheckTweet.new(tweet, @tweet_reviews[tweet.id])
      end
    end
    @tweets = tweets.values.reverse.select { |t| t.created_at > Date.parse('2016/7/1') }
  end

  def july_soundcheck_tweets
    Rails.cache.fetch('julysoundcheck_tweets', expires_in: 5.minutes) do
      twitter_client.search("#julysoundcheck -rt").to_a.reverse
    end
  end
end
