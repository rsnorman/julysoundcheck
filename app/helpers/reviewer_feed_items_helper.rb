module ReviewerFeedItemsHelper
  def user_name
    return "@#{@screen_name}" if @user.nil?
    @user.name || @user.screen_name
  end

  def twitter_profile?
    @user.twitter_id
  end

  def available_stats?
    @feed_items.detect { |fi| fi.feedable_type == 'TweetReview' }
  end
end
