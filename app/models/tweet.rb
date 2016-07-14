class Tweet < ApplicationRecord
  validates :tweet_id, uniqueness: true
end
