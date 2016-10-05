require './lib/error_logger'

module Archiver
  class TweetArchiver
    def self.archive
      new.archive
    end

    def initialize(archived_tweets = Tweet.all)
      @archived_tweets = archived_tweets
    end

    def archive
      client.search('#julysoundcheck', since_id: since_id).to_a.reverse.map do |tweet|
        begin
          TweetCreator.new(tweet).create unless tweet.retweet?
        rescue Exception => exception
          ErrorLogger.log(exception, tweet_id: tweet.id, tweet_text: tweet.text)
        end
      end
    end

    private

    def since_id
      @archived_tweets.first.try(:tweet_id)
    end

    def client
      TwitterClient.instance
    end
  end
end
