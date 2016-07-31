class ReviewerFeedItemsController < ApplicationController
  before_action :set_user, only: :index
  before_action :set_feed_items, only: :index

  private

  def set_user
    @screen_name = params[:screen_name]
    @user = User.find_by(twitter_screen_name: @screen_name)
    @user ||= User.find_by(slug: @screen_name)
  end

  def set_feed_items
    @feed_items = FeedItem.none.page(1) and return unless @user
    @feed_items = FeedItem
      .where(user: @user)
      .order(created_at: :desc)
      .page(params[:page])
  end
end
