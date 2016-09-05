module SheetSync
  module Download
    class TweetReviewRowParser
      def initialize(row, review_tweet: nil,
                          rating_score_convertor: Rating)
        fail ArgumentError, 'Review tweet cannot be nil' unless review_tweet
        @row = row
        @review_tweet = review_tweet
        @rating_score_convertor = rating_score_convertor
      end

      def parse
        @review_attributes ||= {
          artist: row.artist,
          album: row.album,
          genre: row.genre,
          listen_url: parse_link(row.source(with_formula: true)),
          twitter_status_id: review_tweet.tweet_id,
          rating: Rating.from_score(row.rating).value,
          tweet: review_tweet.in_reply_to_tweet || review_tweet,
          user: review_tweet.user,
          album_of_the_month: !row.aotm.blank?
        }.keep_if { |_attr_name, attr_value| !attr_value.nil? && attr_value != '' }
      end

      private

      attr_reader :row, :review_tweet

      def parse_link(cell_formula)
        cell_formula.split('"').second
      end
    end
  end
end
