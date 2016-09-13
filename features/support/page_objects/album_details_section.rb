class AlbumDetailsSection < SitePrism::Section
  element :artist, 'strong'
  element :album, 'span'
  element :genre, 'em'
end
