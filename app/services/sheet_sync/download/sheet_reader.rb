module SheetSync
  module Download
    class SheetReader
      attr_reader :worksheet

      def self.download
        new.download
      end

      def initialize(tweet_reviews: TweetReview.all, worksheet: Worksheet.new)
        @tweet_reviews = tweet_reviews.includes(:tweet)
        @worksheet = worksheet
        @existing_reviews ||= {}
      end

      def download
        worksheet.each_row do |row|
          begin
            downloader_for(row).download
          rescue Exception => exception
            Rollbar.error(exception, artist: row.artist, album: row.album)
          end
        end
      end

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
