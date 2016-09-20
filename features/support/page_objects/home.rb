require_relative 'review_section'
require_relative 'tweet_review_section'
require_relative 'tweet_section'
require_relative 'twitter_sidebar_section'
require_relative 'recent_tweets_section'

class Home < SitePrism::Page
  set_url '/'
  element :no_reviews, '#no_reviews'
  sections :reviews, ReviewSection, '.review-item'
  sections :tweet_reviews, TweetReviewSection, '.tweet-review-item'
  sections :tweets, TweetSection, '.tweet-item'
  section :twitter_sidebar, TwitterSidebarSection, '#twitter_sign_in'
  section :recent_tweets, RecentTweetsSection, '#recent_tweets'
end
