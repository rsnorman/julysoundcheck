require_relative 'album_details_section'

class ReviewSection < SitePrism::Section
  element :user_name, '.user-name'
  element :reviewed_on, '.reviewed-on'
  element :rating, '.review-rating'
  element :review_text, '.tweet-text'
  sections :album_details, AlbumDetailsSection, '.genre'
end
