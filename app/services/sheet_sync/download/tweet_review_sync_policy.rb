module SheetSync
  module Download
    class TweetReviewSyncPolicy
      def initialize(review_tweet, review_attributes)
        @review_tweet = review_tweet
        @review_attributes = review_attributes
      end

      def sync?
        tweet_review.nil? ||
          tweet_review.rating.value != review_attributes[:rating] ||
          tweet_review.listen_url.blank? ||
          tweet_review.genre.blank? ||
          tweet_review.album_of_the_month != review_attributes[:album_of_the_month]
      end

      private

      attr_reader :review_tweet, :review_attributes

      def tweet_review
        review_tweet.tweet_review || review_tweet.in_reply_to_tweet.try(:tweet_review)
      end
    end
  end
end
