module Archiver
  class TweetUpdater
    def initialize(tweets = Tweet.all, parser = TweetParser)
      @tweets = tweets
      @tweet_store = tweets.inject({}) { |m, t| m.merge(t.tweet_id.to_i => t) }
      @parser = parser
    end

    def update
      tweets.each do |tweet|
        @tweet_store[tweet.id].try(:update, @parser.parse(tweet))
      end
    end

    private

    def tweets
      client.statuses(@tweets.pluck(:tweet_id))
    end

    def client
      TwitterClient.instance
    end
  end
end
