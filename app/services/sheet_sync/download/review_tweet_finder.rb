module SheetSync
  module Download
    class ReviewTweetFinder
      def initialize(row, twitter_client: TwitterClient.instance,
                     tweet_creator: Archiver::TweetCreator)
        @row = row
        @twitter_client = twitter_client
        @tweet_creator = tweet_creator
      end

      def find
        Tweet.find_by(tweet_id: review_tweet_id) || create_tweet
      end

      private

      attr_reader :twitter_client, :row

      def create_tweet
        @tweet_creator.new(twitter_client.status(review_tweet_id)).create
      end

      def review_tweet_id
        parse_tweet_id(row.tweet(with_formula: true))
      end

      def parse_tweet_id(cell_formula)
        parse_link(cell_formula).split('/').last.split('?').first
      end

      def parse_link(cell_formula)
        cell_formula.split('"').second
      end
    end
  end
end
