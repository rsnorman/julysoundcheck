module ReviewerFeedItemsHelper
  def user_name
    return "@#{@screen_name}" if @user.nil?
    @user.name || @user.screen_name
  end

  def twitter_profile?
    @user.twitter_id
  end
end
