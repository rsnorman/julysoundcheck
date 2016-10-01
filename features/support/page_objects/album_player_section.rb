class AlbumPlayerSection < SitePrism::Section
  element :player, 'iframe'

  def has_album?(album_id)
    has_embed_link?("https://embed.spotify.com/?uri=spotify:album:#{album_id}&theme=white")
  end

  def has_embed_link?(url)
    player[:src].start_with?(url)
  end
end
