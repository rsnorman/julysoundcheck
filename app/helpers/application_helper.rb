module ApplicationHelper
  include TwitterUser

  def signed_in?
    user_session || twitter_user.present?
  end

  def current_user
    @current_user ||= super() || User.find_by(twitter_id: twitter_user.id)
  end

  def twitter_user?
    !!twitter_user
  end
end
