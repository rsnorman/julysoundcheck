module ApplicationHelper
  include TwitterUser

  def signed_in?
    user_session || twitter_user.present?
  end

  def current_user
    @current_user ||= super() || (twitter_user && User.find_by(twitter_id: twitter_user.id))
  end

  def twitter_user?
    !!twitter_user
  end

  def reviewer_path(user)
    return super(user) if user.is_a?(String)
    user.twitter_screen_name ?
      super(user.twitter_screen_name) :
      super(user.id)
  end
end
