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
      row.review = "=HYPERLINK(\"#{tweet_link(tweet_review)}\", \"#{tweet_text(tweet_review)}\")"
      row.reviewer = reviewer(tweet_review)
      row.date_reviewed = tweet_review.tweet.tweeted_at.strftime('%b/%e/%Y')
      row.rating = tweet_review.rating.short_description
      row.genre = tweet_review.genre
      row.aotm = tweet_review.album_of_the_month ? '*******' : nil
      worksheet.save
    end

    def review_row_for(tweet_review)
      ReviewRowFinder.new(worksheet).find(tweet_review)
    end

    def tweet_link(tweet_review)
      tweet = tweet_review.tweet
      "https://www.twitter.com/#{tweet.user.twitter_screen_name}/status/#{tweet.tweet_id}"
    end

    def tweet_text(tweet_review)
      tweet = tweet_review.tweet
      tweet = tweet.reply if tweet.reply
      tweet.text.gsub('"', '""')
    end

    def reviewer(tweet_review)
      tweet_review.user.name || tweet_review.user.twitter_name
    end
  end
end
