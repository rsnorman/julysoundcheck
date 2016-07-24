module Archiver
  class TweetUserMover
    def self.create
      new.create
    end

    def initialize(tweets = Tweet.all)
      @tweets = tweets
    end

    def create
      tweet_users.each do |tweet|
        User.create(twitter_name: tweet.name,
                    twitter_screen_name: tweet.screen_name,
                    twitter_id: twitter_id_for_screen_name(tweet.screen_name),
                    profile_image_uri: tweet.user.profile_image_uri)
      end

      update_tweet_users
      update_tweet_review_users
    end

    private

    def update_tweet_users
      @tweets.each do |tweet|
        user = User.find_by(twitter_screen_name: tweet.screen_name)
        tweet.update(user: user)
      end
    end

    def update_tweet_review_users
      @tweets.collect(&:tweet_review).compact.each do |tweet_review|
        next if tweet_review.tweet.nil?
        user = User.find_by(twitter_screen_name: tweet_review.tweet.screen_name)
        tweet_review.update(user: user)
      end
    end

    def tweet_users
      @tweets
        .reject do |tweet|
          User.exists?(twitter_screen_name: tweet.screen_name)
        end
        .map do |tweet|
          {name: tweet.name, screen_name: tweet.screen_name}
        end
        .uniq
        .map { |tweet_hash| OpenStruct.new(tweet_hash) }
    end

    def twitter_id_for_screen_name(screen_name)
      TwitterClient.instance.user(screen_name).id
    end
  end
end
