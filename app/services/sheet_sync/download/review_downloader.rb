module SheetSync
  module Download
    class ReviewDownloader
      attr_reader :row

      def initialize(row)
        @row = row
      end

      def download
        sync
      end

      private

      def sync(review_attributes)
        if tweet_review
          tweet_review.update(review_attributes)
        else
          TweetReview.create(review_attributes)
        end
      end

      def tweet_review
        user.tweet_reviews.find(artist: review_attributes[:artist],
                                album: review_attributes[:album])
      end

      def user
        @user ||=
          User.find_by(name: row.reviewer) || User.new(name: row.reviewer)
      end

      def review_attributes
        @review_attributes ||= {
          artist: row.artist,
          album: row.album,
          genre: row.genre,
          listen_url: parse_link(row.source(with_formula: true)),
          rating: Rating.from_score(row.rating).value,
          text: row.review
        }.keep_if { |_attr_name, attr_value| !attr_value.blank? }
      end

      def parse_link(cell_formula)
        cell_formula.split('"').second
      end
    end
  end
end
