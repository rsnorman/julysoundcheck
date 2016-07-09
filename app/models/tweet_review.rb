class TweetReview < ApplicationRecord
  def rating
    Rating.new(super())
  end

  def listen_url
    ListenUrl.new(super())
  end
end
