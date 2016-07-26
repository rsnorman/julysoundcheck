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
      client.search('#julysoundcheck', since_id: since_id).to_a.reverse.map do |tweet|
        begin
          unless tweet.retweet?
            tweet = Tweet.create!(@parser.parse(tweet))
            FeedItemCreator.new(tweet).create
          end
        rescue Exception => exception
          Rollbar.error(exception, tweet_id: tweet.id, tweet_text: tweet.text)
        end
      end
      TweetUserCreator.new(new_tweets).create
    end

    private

    def since_id
      @archived_tweets.first.tweet_id
    end

    def client
      TwitterClient.instance
    end

    def new_tweets
      Tweet.where("tweet_id > '#{since_id}'")
    end
  end
end
