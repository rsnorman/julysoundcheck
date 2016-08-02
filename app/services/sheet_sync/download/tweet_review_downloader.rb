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

      def sync
        if tweet_review
          tweet_review.update(review_attributes)
        else
          tweet_review = TweetReview.create!(review_attributes)
          FeedItemCreator.new(tweet_review).create
        end
      end

      def sync?
        tweet_review.nil? ||
          tweet_review.rating.value != review_attributes[:rating] ||
          tweet_review.listen_url.blank? ||
          tweet_review.genre.blank? ||
          tweet_review.album_of_the_month != review_attributes[:album_of_the_month]
      end

      def tweet_review
        review_tweet.tweet_review || review_tweet.in_reply_to_tweet.try(:tweet_review)
      end

      def review_attributes
        @review_attributes ||= {
          artist: row.artist,
          album: row.album,
          genre: row.genre,
          listen_url: parse_link(row.source(with_formula: true)),
          twitter_status_id: review_tweet_id,
          rating: Rating.from_score(row.rating).value,
          tweet: review_tweet.in_reply_to_tweet || review_tweet,
          user: review_tweet.user,
          album_of_the_month: !row.aotm.blank?
        }.keep_if { |_attr_name, attr_value| !attr_value.blank? }
      end

      def review_tweet
        @review_tweet ||= Tweet.find_by(tweet_id: review_tweet_id)
        @review_tweet ||= Archiver::TweetCreator.new(twitter_client.status(review_tweet_id)).create
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

      def twitter_client
        TwitterClient.instance
      end
    end
  end
end
