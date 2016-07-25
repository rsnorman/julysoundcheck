class FeedItem < ApplicationRecord
  belongs_to :feedable, polymorphic: true
  belongs_to :user
end
