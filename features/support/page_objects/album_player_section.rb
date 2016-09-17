class AlbumPlayerSection < SitePrism::Section
  element :player, 'iframe'

  def has_album?(album_id)
    player[:src] == "https://embed.spotify.com/?uri=spotify:album:#{album_id}&theme=white"
  end
end
