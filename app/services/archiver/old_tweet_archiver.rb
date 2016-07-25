module Archiver
  class OldTweetArchiver
    DEFAULT_TWEETS_FILEPATH = './db/old_tweets.txt'.freeze

    def self.archive
      new.archive
    end

    def initialize(archived_tweets: Tweet.all,
                   repo_filepath: DEFAULT_TWEETS_FILEPATH,
                   parser: TweetParser)
      @archived_tweets = archived_tweets
      @repo_filepath = repo_filepath
      @parser = parser
    end

    def archive
      tweets.map do |tweet|
        Tweet.create(@parser.parse(tweet)).tap do |tweet|
          FeedItemCreator.new(tweet).create
        end
      end.tap do |new_tweets|
        TweetUserCreator.new(new_tweets).create
      end
    end

    private

    def tweets
      client.statuses(tweet_ids)
    end

    def tweet_ids
      (File.read(@repo_filepath).split("\n") - saved_tweet_ids).map(&:to_i)
    end

    def saved_tweet_ids
      @archived_tweets.pluck(:tweet_id).map(&:to_s)
    end

    def client
      TwitterClient.instance
    end
  end
end
