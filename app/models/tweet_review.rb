class TweetReview < ApplicationRecord
  def rating
    Rating.new(super())
  end

  def listen_source
    return unless listen_url
    ListenSource.new(listen_url)
  end
end
