require_relative 'album_details_section'
require_relative 'album_player_section'

class ReviewSection < SitePrism::Section
  element :user_name, '.user-name'
  element :reviewed_on, '.reviewed-on'
  element :rating, '.review-rating'
  element :review_text, '.tweet-text'
  element :aotm_badge, '.album-of-the-month'
  section :album_details, AlbumDetailsSection, '.genre'
  section :album_player, AlbumPlayerSection, '.listen-embed'

  def reviewed_on?(datetime)
    reviewed_on.has_content? datetime.to_date.to_formatted_s(:long_ordinal)
  end
end
