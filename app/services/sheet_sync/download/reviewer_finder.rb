module SheetSync
  module Download
    class ReviewerFinder
      def initialize(row)
        @row = row
      end

      def find
        User.find_by(name: row.reviewer) || User.create(name: row.reviewer)
      end

      private

      attr_reader :row
    end
  end
end
