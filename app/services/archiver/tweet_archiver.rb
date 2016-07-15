module Archiver
  class TweetArchiver
    def self.archive
      new.archive
    end

    def initialize(archived_tweets = Tweet.all, parser: TweetParser)
      @archived_tweets = archived_tweets
      @parser = parser
    end

    def archive
      client.search('#julysoundcheck', since_id: since_id).map do |tweet|
        Tweet.create(@parser.parse(tweet))
      end
    end

    private

    def since_id
      @archived_tweets.first.tweet_id
    end

    def client
      TwitterClient.instance
    end
  end
end
