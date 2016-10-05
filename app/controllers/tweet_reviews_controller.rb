class TweetReviewsController < ApplicationController
  before_action :set_tweet_review, only: [:edit, :update]
  before_action :set_tweet, only: :new
  before_action :set_jsc_tweet, only: [:new, :edit]

  def new
    @tweet_review =
      @tweet.build_tweet_review(rating: @jsc_tweet.rating,
                                twitter_status_id: @tweet.tweet_id)
  end

  def create
    @tweet_review = TweetReview.create(tweet_review_params)
    FeedItemCreator.new(@tweet_review).create
    sync_tweet_review if sync?
    redirect_to root_path, notice: notice_message
  end

  def update
    @tweet_review.update(tweet_review_params)
    sync_tweet_review if sync?
    redirect_to root_path, notice: notice_message
  end

  private

  def notice_message
    message = 'Tweet updated with review'
    message += ' and synced to spreadsheet' if sync?
    message
  end

  def set_tweet
    @tweet = Tweet.find(params[:tweet_id])
  end

  def set_jsc_tweet
    @jsc_tweet = JulySoundcheckTweet.new(@tweet || @tweet_review.tweet)
  end

  def set_tweet_review
    @tweet_review = TweetReview.find(params[:id])
  end

  def tweet_review_params
    params
      .require(:tweet_review)
      .permit(
        :tweet_id, :twitter_status_id, :rating, :artist, :album,
        :listen_url, :genre, :album_of_the_month
      ).tap do |p|
        p[:user] = Tweet.find(p[:tweet_id]).user
      end
  end

  def sync_tweet_review
    SheetSync::Uploader.upload(@tweet_review)
  end

  def sync?
    params[:commit].end_with?('Sync')
  end
end
