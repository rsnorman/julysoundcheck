module Archiver
  class TweetParser
    attr_reader :tweet

    def self.parse(tweet)
      new(tweet).to_hash
    end

    def initialize(tweet)
      @tweet = tweet
    end

    def to_hash
      {
        tweet_id: tweet.id,
        name: tweet.user.name,
        screen_name: tweet.user.screen_name,
        text: tweet.text,
        tweeted_at: tweet.created_at,
        in_reply_to_status_id: tweet.in_reply_to_status_id,
        profile_image_uri: tweet.user.profile_image_uri(:bigger),
        in_reply_to_tweet: Tweet.find_by(tweet_id: tweet.in_reply_to_status_id)
      }
    end
  end
end
