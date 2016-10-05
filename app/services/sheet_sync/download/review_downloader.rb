module SheetSync
  module Download
    class ReviewDownloader
      def initialize(row, row_parser: ReviewRowParser,
                     review_syncer: ReviewSyncer,
                     reviewer_finder: ReviewerFinder)
        @row_parser = row_parser.new(row)
        @review_syncer = review_syncer.new(type: :review,
                                           reviewer_finder: reviewer_finder.new(row))
      end

      def download
        @review_syncer.sync(review_attributes)
      end

      private

      def review_attributes
        @row_parser.parse
      end
    end
  end
end
