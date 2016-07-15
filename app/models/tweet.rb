class Tweet < ApplicationRecord
  belongs_to :in_reply_to_tweet, class_name: 'Tweet'
  has_one :reply, foreign_key: :in_reply_to_tweet_id, class_name: 'Tweet'
  has_one :tweet_review

  validates :tweet_id, uniqueness: true
end
