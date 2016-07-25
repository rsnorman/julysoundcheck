module FeedItemsHelper
  def feed_item_locals(feed_item)
    presenter = july_soundcheck_presenter_for(feed_item.feedable_type)
    {feed_item.feedable_type.underscore.to_sym => presenter.new(feed_item.feedable, feed_item)}
  end

  private

  def july_soundcheck_presenter_for(feedable_type)
    if feedable_type == 'Tweet'
      JulySoundcheckTweet
    elsif feedable_type == 'Review'
      JulySoundcheckReview
    else
      JulySoundcheckTweetReview
    end
  end
end
