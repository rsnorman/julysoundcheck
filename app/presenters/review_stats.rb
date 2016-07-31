class ReviewStats
  attr_reader :reviews

  def initialize(reviews = TweetReview.all)
    @reviews = reviews.includes(tweet: :reply)
  end

  def total_reviews
    reviews.count
  end

  def average_rating
    Rating.new(reviews.average(:rating).round)
  end

  def longest_streak
    last_day = 0
    streak = 0
    longest_streak = 0
    review_days.each do |day|
      if day - 1 == last_day
        streak += 1
      else
        streak = 0
      end
      longest_streak = streak if streak >= longest_streak
      last_day = day
    end
    longest_streak
  end

  def review_days
    reviews.collect do |tr|
        tr.tweet.try(:reply).try(:tweeted_at) ||
        tr.tweet.try(:tweeted_at) ||
        tr.reviewed_at ||
        tr.created_at
    end.collect(&:day).sort
  end
end
