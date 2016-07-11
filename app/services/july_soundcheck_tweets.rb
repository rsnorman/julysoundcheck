class JulySoundcheckTweets
  def initialize(year: Date.current.year,
                 tweet_reviews: TweetReview.all,
                 twitter_client: nil,
                 reviewer: nil)
    @year = year
    @tweet_reviews = tweet_reviews
    @twitter_client = twitter_client
    @reviewer = reviewer
  end

  # @TODO: Clean up this method
  def all
    tweets = {}
    july_soundcheck_tweets.each do |tweet|
      if tweets[tweet.in_reply_to_status_id]
        if tweets[tweet.in_reply_to_status_id].tweet_review.nil?
          tweets[tweet.in_reply_to_status_id] = JulySoundcheckTweet.new(tweets[tweet.in_reply_to_status_id].tweet, tweet_reviews[tweet.id])
        end
        tweets[tweet.in_reply_to_status_id].review_tweet = tweet
      else
        tweets[tweet.id] = JulySoundcheckTweet.new(tweet, tweet_reviews[tweet.id])
      end
    end
    tweets.values.reverse.select { |t| t.created_at > Date.parse("#{@year}/7/1") }
  end

  def july_soundcheck_tweets
    Rails.cache.fetch(query_string, expires_in: 5.minutes) do
      @twitter_client.search(query_string).to_a.reverse
    end
  end

  def tweet_reviews
    @tweet_reviews.inject({}) do |tweet_reviews, tweet_review|
      tweet_reviews.merge(tweet_review.tweet_id.to_i => tweet_review)
    end
  end

  def query_string
    "#{"from:#{@reviewer} " if @reviewer}#julysoundcheck -rt"
  end
end
