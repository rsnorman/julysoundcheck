module Archiver
  class TweetUserCreator
    attr_reader :tweet

    def self.create
      new.create
    end

    def initialize(tweet)
      @tweet = tweet
    end

    def create
      tweet.update(user: user_for_tweet(tweet))
    end

    private

    def user_for_tweet(tweet)
      twitter_user = twitter_user_for_tweet_id(tweet.tweet_id)
      user = User.find_by(twitter_id: twitter_user.id)
      user ||= User.create!(twitter_name: twitter_user.name,
                           twitter_screen_name: twitter_user.screen_name,
                           twitter_id: twitter_user.id,
                           profile_image_uri: twitter_user.profile_image_uri,
                           email: "julysoundcheck+#{twitter_user.screen_name}@gmail.com",
                           password: SecureRandom.uuid)
    end

    def twitter_user_for_tweet_id(tweet_id)
      TwitterClient.instance.status(tweet_id).user
    end
  end
end
