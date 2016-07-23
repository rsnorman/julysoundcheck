module SheetSync
  module Download
    class TweetReviewDownloader
      attr_reader :row

      def initialize(row)
        @row = row
      end

      def download
        sync if sync?
      end

      private

      def sync(review_attributes)
        if tweet_review
          tweet_review.update(review_attributes)
        else
          tweet_review = TweetReview.create!(review_attributes)
          FeedItemCreator.new(tweet_review).create
        end
      end

      def sync?(review_attributes)
        tweet_review.nil? ||
          tweet_review.rating.value != review_attributes[:rating] ||
          tweet_review.listen_url.blank? ||
          tweet_review.genre.blank?
      end

      def tweet_review
        review_tweet.tweet_review
      end

      def review_attributes
        @review_attributes ||= {
          artist: row.artist,
          album: row.album,
          genre: row.genre,
          listen_url: parse_link(row.source(with_formula: true)),
          twitter_status_id: tweet_id,
          rating: Rating.from_score(row.rating).value,
          tweet: review_tweet.in_reply_to_tweet || review_tweet,
          user: review_tweet.user
        }.keep_if { |_attr_name, attr_value| !attr_value.blank? }
      end

      def review_tweet
        @review_tweet ||= Tweet.find_by(tweet_id: review_tweet_id)
      end

      def review_tweet_id
        tweet_id = parse_tweet_id(row.tweet(with_formula: true))
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