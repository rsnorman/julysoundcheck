class ListenSource
  attr_reader :url

  def initialize(url)
    @url = url
  end

  def album_id
    url.split('/').last
  end

  def spotify?
    url.include?('spotify')
  end
end
