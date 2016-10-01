class FeedItem < ApplicationRecord
  belongs_to :feedable, polymorphic: true
  belongs_to :user

  validates :feedable_id, uniqueness: { scope: :feedable_type }
end
