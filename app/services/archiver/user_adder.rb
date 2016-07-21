module Archiver
  class UserAdder
    attr_reader :user

    def initialize(user)
      @user = user
    end

    def add_to_all_tweets
      tweets.each do |tweet|
        tweet.update(user: user)
      end
    end

    def add_to_all_tweet_reviews
      tweets
        .map(&:tweet_review)
        .compact
        .uniq
        .each { |tr| tr.update(user: user) }
    end

    private

    def tweets
      @tweets ||= Tweet.where(screen_name: user.twitter_screen_name)
    end
  end
end
