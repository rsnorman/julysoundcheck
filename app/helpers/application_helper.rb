module ApplicationHelper
  def signed_in?
    twitter_user.present?
  end
end
