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

  def user_path(user)
    user.twitter_screen_name ?
      reviewer_path(user.twitter_screen_name) :
      reviewer_path(user.id)
  end
end
