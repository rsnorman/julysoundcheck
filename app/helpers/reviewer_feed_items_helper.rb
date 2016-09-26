module ReviewerFeedItemsHelper
  def user_name
    return "@#{@screen_name}" unless @user
    @user.name || @user.screen_name
  end

  def twitter_profile?
    return false unless @user
    @user.twitter_id
  end
end
