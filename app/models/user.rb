class User < ApplicationRecord
  has_many :tweets
  has_many :tweet_reviews
  has_many :reviews
  has_many :feed_items

  def name
    super() || twitter_name
  end
end
