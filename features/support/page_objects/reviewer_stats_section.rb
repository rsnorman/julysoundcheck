class ReviewStatsSection < SitePrism::Section
  element :total_reviews_stat, '#total_reviews_stat'
  element :average_rating_stat, '#average_rating_stat'
  element :longest_streak_stat, '#longest_streak_stat'
end
