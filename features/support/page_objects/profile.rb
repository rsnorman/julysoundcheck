require_relative 'review_section'
require_relative 'tweet_review_section'
require_relative 'tweet_section'
require_relative 'pagination_section'
require_relative 'reviewer_stats_section'

class Profile < SitePrism::Page
  set_url '/reviewers/{name}/feed'

  sections :reviews, ReviewSection, '.review-item'
  sections :tweet_reviews, TweetReviewSection, '.tweet-review-item'
  sections :tweets, TweetSection, '.tweet-item'
  section :pagination, PaginationSection, '.pagination'
  section :reviewer_stats, ReviewStatsSection, '#reviewer_stats'
  element :twitter_profile_link, '#twitter_profile_link'
  element :title, '#page_title h2'

  def has_user?(name)
    title.text == "#{name} Reviews"
  end
end
