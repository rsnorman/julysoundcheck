class TweetReview < ApplicationRecord
  belongs_to :tweet, required: false
  belongs_to :user
  has_one :feed_item, as: :feedable

  validates :album, uniqueness: {scope: [:artist, :user_id]}

  before_save :set_album_id

  def rating
    Rating.new(super())
  end

  def listen_source
    return unless listen_url
    ListenSource.new(listen_url)
  end

  private

  def set_album_id
    return unless listen_url
    self.album_source_id ||= AlbumIdFetcher.new(listen_source).fetch
  end
end
