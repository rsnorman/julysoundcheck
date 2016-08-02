module Archiver
  class TweetCreator

    def initialize(twitter_tweet, parser: TweetParser)
      @twitter_tweet = twitter_tweet
      @parser = parser
    end

    def create
      Tweet.create!(@parser.parse(@twitter_tweet)).tap do |tweet|
        FeedItemCreator.new(tweet).create
        TweetUserCreator.new(tweet).create
      end
    end
  end
end
