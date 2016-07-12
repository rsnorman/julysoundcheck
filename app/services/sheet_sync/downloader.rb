module SheetSync
  class Downloader
    attr_reader :worksheet

    def self.download
      new.download
    end

    def initialize(tweet_reviews: TweetReview.all, worksheet: Worksheet.new)
      @tweet_reviews = tweet_reviews
      @worksheet = worksheet
      @existing_reviews ||= {}
    end

    def download
      worksheet.each_row do |row|
        next unless syncable?(row)
        review_attributes = parse_review(row)
        sync_review(review_attributes) if resync_review?(review_attributes)
      end
    end

    def sync_review(review_attributes)
      if (tweet_review = tweet_review_for(review_attributes))
        tweet_review.update(review_attributes)
      else
        TweetReview.create(review_attributes)
      end
    end

    def resync_review?(review_attributes)
      tweet_review = tweet_review_for(review_attributes)
      tweet_review.nil? || tweet_review.rating.value != review_attributes[:rating]
    end

    def tweet_review_for(review_attributes)
      @existing_reviews[review_attributes[:tweet_id]] ||=
        @tweet_reviews.find_by(tweet_id: review_attributes[:tweet_id])
    end

    def syncable?(row)
      row.tweet(with_formula: true).starts_with?('=HYPERLINK')
    end

    def parse_review(row)
      {
        artist: row.artist,
        album: row.album,
        listen_url: parse_link(row.source(with_formula: true)),
        tweet_id: parse_tweet_id(row.tweet(with_formula: true)),
        rating: Rating.from_score(row.rating).value
      }
    end

    def parse_link(cell_formula)
      cell_formula.split('"').second
    end

    def parse_tweet_id(cell_formula)
      parse_link(cell_formula).split('/').last
    end
  end
end
