class User < ApplicationRecord
  has_many :tweets
  has_many :tweet_reviews

  def name
    super() || twitter_name
  end
end
