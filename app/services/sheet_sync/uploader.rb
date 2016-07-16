module SheetSync
  class Uploader
    attr_reader :worksheet

    def self.upload(tweet_review)
      new.upload(tweet_review)
    end

    def initialize(worksheet = Worksheet.new)
      @worksheet = worksheet
    end

    def upload(tweet_review)
      row = review_row_for(tweet_review) || worksheet.build_row
      row.artist = tweet_review.artist
      row.album = tweet_review.album
      row.source = "=HYPERLINK(\"#{tweet_review.listen_url}\",\"#{tweet_review.listen_source.source.to_s.titleize}\")"
      row.tweet = "=HYPERLINK(\"#{tweet_link(tweet_review)}\", \"#{tweet_text(tweet_review)}\")"
      row.reviewer = reviewer(tweet_review) if row.reviewer.blank?
      row.date_reviewed = tweet_review.tweet.tweeted_at.strftime('%b/%e/%Y')
      row.rating = tweet_review.rating.short_description
      row.genre = tweet_review.genre
      worksheet.save
    end

    def review_row_for(tweet_review)
      ReviewRowFinder.new(worksheet).find(tweet_review)
    end

    def tweet_link(tweet_review)
      tweet = tweet_review.tweet
      "https://www.twitter.com/#{tweet.screen_name}/status/#{tweet.tweet_id}"
    end

    def tweet_text(tweet_review)
      tweet_review.tweet.text.gsub('"', '""')
    end

    def reviewer(tweet_review)
      tweet_review.tweet.name
    end
  end
end
