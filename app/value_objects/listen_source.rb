class ListenSource
  attr_reader :url

  def initialize(url)
    @url = url
  end

  def source
    if url.include?('spotify')
      if playlist?
        :link
      else
        :spotify
      end
    elsif url.include?('bandcamp')
      :bandcamp
    elsif url.include?('youtube')
      :youtube
    elsif url.include?('soundcloud')
      :soundcloud
    else
      :link
    end
  end

  private

  def playlist?
    url.include?('playlist') || url.include?('&list=')
  end
end
