module SheetSync
  class Downloader
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
        next unless syncable?(row)
        begin
          review_attributes = parse_review(row)
          sync_review(review_attributes) if resync_review?(review_attributes)
        rescue Exception => exception
          Rollbar.error(exception, artist: row.artist, album: row.album)
        end
      end
    end

    private

    def sync_review(review_attributes)
      if (tweet_review = tweet_review_for(review_attributes))
        tweet_review.update(review_attributes)
      else
        create_tweet_review_feed_item(review_attributes)
      end
    end

    def create_tweet_review_feed_item(review_attributes)
      tweet_review = TweetReview.create!(review_attributes)
      FeedItemCreator.new(tweet_review).create
    end

    def resync_review?(review_attributes)
      tweet_review = tweet_review_for(review_attributes)
      tweet_review.nil? ||
        tweet_review.rating.value != review_attributes[:rating] ||
        tweet_review.listen_url.blank? ||
        tweet_review.genre.blank?
    end

    def tweet_review_for(review_attributes)
      review_attributes[:tweet].try(:tweet_review)
    end

    def syncable?(row)
      row.tweet(with_formula: true).starts_with?('=HYPERLINK')
    end

    def parse_review(row)
      tweet_id = parse_tweet_id(row.tweet(with_formula: true))
      tweet = Tweet.find_by(tweet_id: tweet_id)
      {
        artist: row.artist,
        album: row.album,
        genre: row.genre,
        listen_url: parse_link(row.source(with_formula: true)),
        twitter_status_id: tweet_id,
        rating: Rating.from_score(row.rating).value,
        tweet: tweet.in_reply_to_tweet || tweet,
        user: tweet.user
      }.keep_if { |_attr_name, attr_value| !attr_value.blank? }
    end

    def parse_link(cell_formula)
      cell_formula.split('"').second
    end

    def parse_tweet_id(cell_formula)
      parse_link(cell_formula).split('/').last.split('?').first
    end
  end
end
