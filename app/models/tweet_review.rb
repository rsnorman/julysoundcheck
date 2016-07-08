class TweetReview < ApplicationRecord
  def rating
    Rating.new(super())
  end
end
