module Archiver
  class TweetUserCreator
    attr_reader :tweets

    def self.create
      new.create
    end

    def initialize(tweets = Tweet.all)
      @tweets = tweets
    end

    def create
      tweets.each do |tweet|
        user = user_for_tweet_id(tweet.tweet_id)
        next if User.find_by(twitter_id: user.id)
        User.create(twitter_name: user.name,
                    twitter_screen_name: user.screen_name,
                    twitter_id: user.id,
                    profile_image_uri: user.profile_image_uri)
      end
    end

    private

    def user_for_tweet_id(twitter_id)
      TwitterClient.instance.status(twitter_id).user
    end
  end
end
