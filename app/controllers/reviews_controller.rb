class ReviewsController < ApplicationController
  before_action :set_reviews, only: :index
  before_action :set_review_feed_items, only: :index

  private

  def set_reviews
    @reviews = TweetReview
      .where(rating: Rating.values_from_score(params[:rating]))
      .page(params[:page])
      .order('tweet_reviews.rating DESC, tweet_reviews.created_at DESC')
  end

  def set_review_feed_items
    @feed_items = @reviews.map(&:feed_item).compact
  end
end
