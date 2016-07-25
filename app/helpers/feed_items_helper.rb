module FeedItemsHelper
  def feed_item_locals(feed_item)
    presenter = "JulySoundcheck#{feed_item.feedable_type}".constantize
    {feed_item.feedable_type.underscore.to_sym => presenter.new(feed_item.feedable, feed_item)}
  end
end
