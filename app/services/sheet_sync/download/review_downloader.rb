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

      def sync
        if review
          review.update!(review_attributes)
        else
          review = user.tweet_reviews.create!(review_attributes)
          FeedItemCreator.new(review, :review).create
        end
      end

      def review
        user.tweet_reviews.find_by(artist: review_attributes[:artist],
                                   album: review_attributes[:album])
      end

      def user
        @user ||=
          User.find_by(name: row.reviewer) || User.create(name: row.reviewer)
      end

      def review_attributes
        reviewed_at = Date.strptime(row.date_reviewed, '%m/%d/%Y')
        reviewed_at = Time.current if Date.today == reviewed_at

        @review_attributes ||= {
          artist: row.artist,
          album: row.album,
          genre: row.genre,
          listen_url: parse_link(row.source(with_formula: true)),
          rating: Rating.from_score(row.rating).value,
          text: row.review,
          reviewed_at: reviewed_at,
          album_of_the_month: !row.aotm.blank?
        }.keep_if { |_attr_name, attr_value| !attr_value.blank? }
      end

      def parse_link(cell_formula)
        cell_formula.split('"').second
      end
    end
  end
end
