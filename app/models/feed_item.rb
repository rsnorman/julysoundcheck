class FeedItem < ApplicationRecord
  belongs_to :feedable, polymorphic: true
end
