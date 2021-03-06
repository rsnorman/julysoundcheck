require './lib/error_logger'

class FeedItemsController < ApplicationController
  skip_before_action :authenticate_user!, only: :index
  before_action :create_new_feed_items, only: :index
  before_action :set_feed_items, only: :index

  private

  def set_feed_items
    @feed_items =
      FeedItem
      .includes(:feedable)
      .order(created_at: :desc)
      .page(params[:page])
  end

  def create_new_feed_items
    # Rails.cache.fetch 'tweet-archiver', expires_in: 5.minutes do
    #   Archiver::TweetArchiver.archive
    # end
  rescue Exception => exception
    ErrorLogger.log(exception)
  end
end
