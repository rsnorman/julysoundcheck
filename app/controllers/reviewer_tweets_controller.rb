class ReviewerTweetsController < ApplicationController
  before_action :set_screen_name, only: :index
  before_action :set_tweets, only: :index

  private

  def set_screen_name
    @screen_name = params[:screen_name]
  end

  def set_tweets
    @tweets = JulySoundcheckTweets
      .new(Tweet.where(screen_name: @screen_name))
      .all
      .map { |t| JulySoundcheckTweet.new(t) }
  end
end
