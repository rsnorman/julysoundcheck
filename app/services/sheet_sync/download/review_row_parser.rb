module SheetSync
  module Download
    class ReviewRowParser
      def initialize(row, rating_score_convertor: Rating)
        @row = row
        @rating_score_convertor = rating_score_convertor
      end

      def parse
        {
          artist: row.artist,
          album: row.album,
          genre: row.genre,
          listen_url: parse_link(row.source(with_formula: true)),
          rating: @rating_score_convertor.from_score(row.rating).value,
          text: row.review,
          reviewed_at: reviewed_at,
          album_of_the_month: !row.aotm.blank?
        }.keep_if { |_attr_name, attr_value| !attr_value.nil? && attr_value != '' }
      end

      private

      attr_reader :row

      def reviewed_at
        @reviewed_at = Date.strptime(row.date_reviewed, '%m/%d/%Y')
        @reviewed_at = Time.current if Date.today == @reviewed_at
        @reviewed_at
      end

      def parse_link(cell_formula)
        cell_formula.split('"').second
      end
    end
  end
end
