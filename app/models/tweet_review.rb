class TweetReview < ApplicationRecord
  belongs_to :tweet
  belongs_to :user

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
    self.album_source_id = AlbumIdFetcher.new(listen_source).fetch
  end
end
