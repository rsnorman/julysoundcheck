module TweetReviewsHelper
  def rating_options
    Rating::RATINGS.to_a.inject({}) do |ratings, rating|
      ratings.merge("#{Rating::DESCRIPTIONS[rating.last]} (#{rating.first})" => rating.last)
    end
  end
end
