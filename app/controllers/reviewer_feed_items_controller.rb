class ReviewerFeedItemsController < ApplicationController
  before_action :set_user, only: :index
  before_action :set_feed_items, only: :index
  before_action :set_review_stats, only: :index

  private

  def set_user
    @screen_name = params[:screen_name]
    @user = User.find_by(twitter_screen_name: @screen_name)
    @user ||= User.find_by(slug: @screen_name)
  end

  def set_feed_items
    (@feed_items = FeedItem.none.page(1)) && return unless @user
    @feed_items = FeedItem
                  .where(user: @user)
                  .order(created_at: :desc)
                  .page(params[:page])
  end

  def set_review_stats
    @stats = ReviewStats.new(TweetReview.where(user: @user))
  end
end
