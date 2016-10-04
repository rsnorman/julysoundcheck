require './lib/error_logger'

module SheetSync
  module Download
    class SheetReader
      attr_reader :worksheet

      def self.download
        new.download
      end

      def initialize(worksheet: Worksheet.new, verbose: false)
        @worksheet = worksheet
        @verbose = verbose
      end

      def download
        worksheet.each_row do |row|
          begin
            puts "Download row: #{row.artist}" if @verbose
            downloader_for(row).download
          rescue Exception => exception
            puts "Failed on #{row.artist} - #{row.album} #{exception}" if @verbose
            ErrorLogger.log(exception, artist: row.artist, album: row.album)
          end
        end
      end

      private

      def downloader_for(row)
        if row.tweet(with_formula: true).starts_with?('=HYPERLINK')
          TweetReviewDownloader.new(row)
        else
          ReviewDownloader.new(row)
        end
      end
    end
  end
end
