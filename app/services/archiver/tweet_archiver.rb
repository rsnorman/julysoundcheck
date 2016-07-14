module Archiver
  class TweetArchiver
    def initialize(archived_tweets = Tweet.all, parser: TweetParser)
      @archived_tweets = archived_tweets
      @parser = parser
    end

    def archive
      client.search('#julysoundcheck', since_id: since_id).each do |tweet|
        Tweet.create(@parser.parse(tweet))
      end
    end

    private

    def since_id
      @archived_tweets.order(:tweet_id).first
    end

    def client
      TwitterClient.instance
    end
  end
end
