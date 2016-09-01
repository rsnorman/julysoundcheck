module SheetSync
  module Download
    class ReviewRowParser
      def initialize(row)
        @row = row
      end

      def parse
        reviewed_at = Date.strptime(row.date_reviewed, '%m/%d/%Y')
        reviewed_at = Time.current if Date.today == reviewed_at

        {
          artist: row.artist,
          album: row.album,
          genre: row.genre,
          listen_url: parse_link(row.source(with_formula: true)),
          rating: Rating.from_score(row.rating).value,
          text: row.review,
          reviewed_at: reviewed_at,
          album_of_the_month: !row.aotm.blank?,
          reviewer: row.reviewer
        }.keep_if { |_attr_name, attr_value| !attr_value.blank? }
      end

      private

      attr_reader :row

      def parse_link(cell_formula)
        cell_formula.split('"').second
      end
    end
  end
end
