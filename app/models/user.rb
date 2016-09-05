class User < ApplicationRecord
  has_many :tweets
  has_many :tweet_reviews
  has_many :feed_items

  before_save :set_slug

  def name
    super() || twitter_name
  end

  private

  def set_slug
    return if name.nil?
    self.slug = name.gsub(/\s/, '_').gsub(/[^\w+]/, '').downcase
  end
end
