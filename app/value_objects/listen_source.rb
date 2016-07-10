class ListenSource
  attr_reader :url

  def initialize(url)
    @url = url
  end

  def album_id
    url.split('/').last
  end

  def source
    if url.include?('spotify')
      :spotify
    elsif url.include?('bandcamp')
      :bandcamp
    elsif url.include?('youtube')
      :youtube
    else
      :link
    end
  end
end
