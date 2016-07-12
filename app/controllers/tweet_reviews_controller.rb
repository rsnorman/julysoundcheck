class TweetReviewsController < ApplicationController
  before_action :set_tweet_review, only: [:edit, :update]
  before_action :set_tweet, only: [:new, :edit]

  def new
    @tweet_review = TweetReview.new(rating: @tweet.rating, tweet_id: tweet_id)
  end

  def create
    @tweet_review = TweetReview.create(tweet_review_params)
    sync_tweet_review if sync?
    Rails.cache.clear
    redirect_to root_path, notice: notice_message
  end

  def update
    @tweet_review.update(tweet_review_params)
    sync_tweet_review if sync?
    Rails.cache.clear
    redirect_to root_path, notice: notice_message
  end

  private

  def notice_message
    message = 'Tweet updated with review'
    message += ' and synced to spreadsheet' if sync?
    message
  end

  def set_tweet
    @tweet = JulySoundcheckTweet.new(tweet, @tweet_review)
  end

  def tweet
    Rails.cache.fetch("tweet_#{tweet_id}") do
      twitter_client.status(tweet_id)
    end
  end

  def set_tweet_review
    @tweet_review = TweetReview.find(params[:id])
  end

  def tweet_id
    params[:tweet_id] || @tweet_review.tweet_id
  end

  def tweet_review_params
    params
      .require(:tweet_review)
      .permit(:tweet_id, :rating, :artist, :album, :listen_url)
  end

  def sync_tweet_review
    SheetSync::Uploader.upload(@tweet_review)
  end

  def sync?
    params.require(:tweet_review).require(:sync) == 'true'
  end
end
