module Archiver
  class TweetCreator
    def initialize(twitter_tweet, parser: TweetParser)
      @twitter_tweet = twitter_tweet
      @parser = parser
    end

    def create
      tweet = Tweet.new(@parser.parse(@twitter_tweet))
      TweetUserCreator.new(tweet).create
      tweet.save
      FeedItemCreator.new(tweet).create
    end
  end
end
