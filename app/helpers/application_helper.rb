module ApplicationHelper
  include TwitterUser

  def signed_in?
    twitter_user.present?
  end

  def current_user
    @current_user ||= User.find_by(twitter_id: twitter_user.id)
  end
end
