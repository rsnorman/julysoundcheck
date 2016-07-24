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
        text: tweet.text,
        tweeted_at: tweet.created_at,
        in_reply_to_status_id: tweet.in_reply_to_status_id,
        profile_image_uri: tweet.user.profile_image_uri(:bigger),
        in_reply_to_tweet: Tweet.find_by(tweet_id: tweet.in_reply_to_status_id),
        user: User.find_by(twitter_id: tweet.user.id)
      }
    end
  end
end
