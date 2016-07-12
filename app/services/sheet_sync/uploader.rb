module SheetSync
  class Uploader
    attr_reader :worksheet

    def self.upload(tweet_review)
      new.upload(tweet_review)
    end

    def initialize(worksheet = Worksheet.new)
      @worksheet = worksheet
      @twitter_client = twitter_client
    end

    def upload(tweet_review)
      row = review_row_for(tweet_review) || worksheet.build_row
      row.artist = tweet_review.artist
      row.album = tweet_review.album
      row.source = "=HYPERLINK(\"#{tweet_review.listen_url}\",\"#{tweet_review.listen_source.source.to_s.titleize}\")"
      row.tweet = "=HYPERLINK(\"#{tweet_link(tweet_review)}\", \"#{tweet_text(tweet_review)}\")"
      row.reviewer = reviewer(tweet_review) if row.reviewer.blank?
      row.date_reviewed = tweet_review.created_at.strftime('%b/%e/%Y')
      row.rating = tweet_review.rating.short_description
      worksheet.save
    end

    def review_row_for(tweet_review)
      ReviewRowFinder.new(worksheet).find(tweet_review)
    end

    def tweet_link(tweet_review)
      tweet = tweet_for(tweet_review.tweet_id)
      "https://www.twitter.com/#{tweet.user.screen_name}/status/#{tweet_review.tweet_id}"
    end

    def tweet_text(tweet_review)
      tweet_for(tweet_review.tweet_id).text.gsub('"', '""')
    end

    def tweet_for(tweet_id)
      @tweet ||= twitter_client.status(tweet_id)
    end

    def reviewer(tweet_review)
      tweet = tweet_for(tweet_review.tweet_id)
      tweet.user.name
    end

    def twitter_client
      @tclient ||= Twitter::REST::Client.new do |config|
        config.consumer_key    = ENV['TWITTER_CONSUMER_KEY']
        config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
      end
    end
  end
end
