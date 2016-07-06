class TweetsController < ApplicationController
  before_action :set_tweets, only: :index

  private

  def set_tweets
    tweets = {}
    twitter_client.search("#julysoundcheck -rt").to_a.reverse.each do |tweet|
      if tweets[tweet.in_reply_to_status_id]
        tweets[tweet.in_reply_to_status_id].review_tweet = tweet
      else
        tweets[tweet.id] = ReviewTweet.new(tweet)
      end
    end
    @tweets = tweets.values.reverse.select { |t| t.created_at > Date.parse('2016/7/1') }
  end

  class ReviewTweet
    attr_reader :tweet
    attr_accessor :review_tweet

    delegate :id, :in_reply_to_status_id, :user, :text, :created_at, to: :tweet

    def initialize(tweet)
      @tweet = tweet
    end

    def review_tweet?
      review_tweet
    end

    def review_text
      review_tweet? ? review_tweet.text : text
    end

    def rating
      /(?:(\d\s*[+|-]?\s*)?#julysoundcheck(\s*\d\s*[+|-]?)?)|(\d\s*[+|-]?)$/i.match(review_text) do |matches|
        matches.to_a.slice(1..-1).compact.first
      end
    end
  end
end
