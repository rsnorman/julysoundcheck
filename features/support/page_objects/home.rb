require_relative 'review_section'
require_relative 'tweet_review_section'
require_relative 'tweet_section'
require_relative 'twitter_sidebar_section'
require_relative 'recent_tweets_section'
require_relative 'pagination_section'
require_relative 'filter_section'
require_relative 'title_bar_menu_section'

class Home < SitePrism::Page
  set_url '/'
  element :no_reviews, '#no_reviews'
  sections :reviews, ReviewSection, '.review-item'
  sections :tweet_reviews, TweetReviewSection, '.tweet-review-item'
  sections :tweets, TweetSection, '.tweet-item'
  section :twitter_sidebar, TwitterSidebarSection, '#twitter_sign_in'
  section :recent_tweets, RecentTweetsSection, '#recent_tweets'
  section :pagination, PaginationSection, '.pagination'
  section :filter, FilterSection, '#ratings_filter'
  element :flash_message, '#notice'
  section :title_bar_menu, TitleBarMenuSection, '#title_bar_menu'

  def has_flash_message?(message)
    flash_message.has_content? message
  end

  def go_sign_in
    title_bar_menu.click_sign_in
    Login.new
  end

  def go_to_profile
    title_bar_menu.click_profile
    Profile.new
  end
end
