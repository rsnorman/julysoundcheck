class AlbumIdFetcher
  def initialize(listen_source)
    @listen_source = listen_source
  end

  def fetch
    case source
    when :spotify
      spotify_album_id
    when :bandcamp
      bandcamp_album_id
    when :youtube
      youtube_album_id
    when :soundcloud
      soundcloud_album_id
    else
      nil
    end
  end

  private

  def source
    return :none unless @listen_source
    @listen_source.source
  end

  def url
    @listen_source.url
  end

  def youtube_album_id
    if playlist?
      url.split('v=').last.gsub('&list=', '?list=')
    else
      url.split('/').last.split('=').last
    end
  end

  def bandcamp_album_id
    page = Nokogiri::HTML(open(url))
    page.children.last.text.strip.split(' ').last
  end

  def soundcloud_album_id
    page = Nokogiri::HTML(open(url))
    page.css('[property="twitter:app:url:googleplay"]').attr('content').text.split(':').last
  end

  def playlist?
    url.include?('playlist') || url.include?('&list=')
  end
end
