class Album
  attr_reader :artist

  def initialize(album_hash)
    @album_hash = album_hash
    @artist = @album_hash.artists.first.name # Artists lazy loaded
  end

  def name
    @album_hash.name
  end

  def release_date
    return if @album_hash.release_date.blank?
    Date.parse(@album_hash.release_date)
  rescue ArgumentError
    nil
  end

  def image_url
    URI(@album_hash.images.second['url'])
  end

  def url
    "https://play.spotify.com/album/#{@album_hash.id}"
  end
end
