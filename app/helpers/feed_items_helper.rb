module FeedItemsHelper
  def feed_item_partial(feed_item)
    "/feed_items/#{feedable_type(feed_item).underscore}_item"
  end

  def feed_item_locals(feed_item)
    presenter = july_soundcheck_presenter_for(feed_item)
    {feedable_type(feed_item).underscore.to_sym => presenter.new(feed_item.feedable, feed_item)}
  end

  private

  def feedable_type(feed_item)
    type = feed_item.feedable_type
    if type == 'TweetReview' && feed_item.feedable.tweet.nil?
      type = 'Review'
    end
    type
  end

  def july_soundcheck_presenter_for(feed_item)
    type = feedable_type(feed_item)
    if type == 'Tweet'
      JulySoundcheckTweet
    elsif type == 'Review'
      JulySoundcheckReview
    else
      JulySoundcheckTweetReview
    end
  end
end
