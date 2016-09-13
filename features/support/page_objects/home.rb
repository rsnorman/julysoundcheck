require_relative 'review_section'

class Home < SitePrism::Page
  set_url '/'
  element :no_reviews, '#no_reviews'
  sections :reviews, ReviewSection, '.review-item'
end
