class TweetsController < ApplicationController
  before_action :set_tweets, only: :index

  private

  def set_tweets
    @tweets = JulySoundcheckTweets.all.map { |t| JulySoundcheckTweet.new(t) }
  end
end
