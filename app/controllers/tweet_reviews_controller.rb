class TweetReviewsController < ApplicationController
  before_action :set_tweet_review, only: [:edit, :update]
  before_action :set_tweet, only: [:new, :edit]

  def new
    @tweet_review = TweetReview.new(rating: @tweet.rating, tweet_id: tweet_id)
  end

  def create
    @tweet_review = TweetReview.create(tweet_review_params)
    Rails.cache.clear
    redirect_to root_path, notice: 'Tweet updated with review'
  end

  def update
    @tweet_review.update(tweet_review_params)
    Rails.cache.clear
    redirect_to root_path, notice: 'Tweet updated with review'
  end

  private

  def set_tweet
    @tweet = JulySoundcheckTweet.new(twitter_client.status(tweet_id), @tweet_review)
  end

  def set_tweet_review
    @tweet_review = TweetReview.find(params[:id])
  end

  def tweet_id
    params[:tweet_id] || @tweet_review.tweet_id
  end

  def tweet_review_params
    params.require(:tweet_review).permit(:tweet_id, :rating)
  end
end
