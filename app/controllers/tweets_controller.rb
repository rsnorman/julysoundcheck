class TweetsController < ApplicationController
  before_action :set_tweets, only: :index

  private

  def set_tweets
    @tweets = JulySoundcheckTweets.new(twitter_client: twitter_client).all
  end
end
