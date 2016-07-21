class User < ApplicationRecord
  has_many :tweets
  has_many :tweet_reviews
end
