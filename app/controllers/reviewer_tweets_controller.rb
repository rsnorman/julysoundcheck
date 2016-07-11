class ReviewerTweetsController < ApplicationController
  before_action :set_screen_name, only: :index
  before_action :set_tweets, only: :index

  private

  def set_screen_name
    @screen_name = params[:screen_name]
  end

  def set_tweets
    @tweets = JulySoundcheckTweets.new(reviewer: params[:screen_name],
                                       twitter_client: twitter_client).all
  end
end
