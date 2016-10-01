module SheetSync
  module Download
    class TweetReviewDownloader
      attr_reader :row

      def initialize(row, row_parser: TweetReviewRowParser,
                          review_syncer: ReviewSyncer,
                          sync_policy: TweetReviewSyncPolicy,
                          review_tweet_finder: ReviewTweetFinder,
                          reviewer_finder: ReviewerFinder)

        @review_tweet_finder = review_tweet_finder.new(row)
        @row_parser = row_parser.new(row, review_tweet: review_tweet)
        @review_syncer = review_syncer.new(type: :tweet_review,
                                           reviewer_finder: reviewer_finder.new(row))
        @sync_policy = sync_policy
      end

      def download
        @review_syncer.sync(review_attributes) if sync?
      end

      private

      def review_attributes
        @row_parser.parse
      end

      def sync?
        @sync_policy.new(review_tweet, review_attributes).sync?
      end

      def review_tweet
        @review_tweet ||= @review_tweet_finder.find
      end
    end
  end
end
