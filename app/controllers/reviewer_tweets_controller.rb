class ReviewerTweetsController < ApplicationController
  before_action :set_tweets, only: :index

  def index
  end

  private

  def set_tweets
    @tweets = JulySoundcheckTweets.new(reviewer: params[:screen_name],
                                       twitter_client: twitter_client).all
  end
end
