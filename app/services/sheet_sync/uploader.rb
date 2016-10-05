module SheetSync
  class Uploader
    attr_reader :worksheet

    def self.upload(tweet_review)
      new.upload(tweet_review)
    end

    def initialize(worksheet: Worksheet.new, review_row_finder: ReviewRowFinder)
      @worksheet = worksheet
      @review_row_finder = review_row_finder
    end

    def upload(tweet_review)
      row = review_row_for(tweet_review) || worksheet.build_row
      row.artist = tweet_review.artist
      row.album = tweet_review.album
      row.source =
        "=HYPERLINK(\"#{tweet_review.listen_url}\"," \
        "\"#{tweet_review.listen_source.source.to_s.titleize}\")"
      row.review = review_text(tweet_review)
      row.reviewer = reviewer(tweet_review)
      row.date_reviewed = reviewed_on(tweet_review)
      row.rating = tweet_review.rating.short_description
      row.genre = tweet_review.genre
      row.aotm = tweet_review.album_of_the_month ? '*******' : nil
      worksheet.save
    end

    def review_row_for(tweet_review)
      @review_row_finder.new(worksheet).find(tweet_review)
    end

    def tweet_link(tweet_review)
      return unless (tweet = tweet_review.tweet)
      tweet_id = tweet.reply ? tweet.reply.tweet_id : tweet.tweet_id
      "https://www.twitter.com/#{tweet.user.twitter_screen_name}/status/#{tweet_id}"
    end

    def tweet_text(tweet_review)
      return unless (tweet = tweet_review.tweet)
      tweet.text.gsub('"', '""')
    end

    def reviewer(tweet_review)
      tweet_review.user.name || tweet_review.user.twitter_name
    end

    def reviewed_on(review)
      review_date = if (tweet = review.tweet)
                      tweet.tweeted_at
                    else
                      review.reviewed_at
                    end
      review_date.strftime('%b/%e/%Y')
    end

    def review_text(review)
      if review.tweet
        "=HYPERLINK(\"#{tweet_link(review)}\", \"#{tweet_text(review)}\")"
      else
        review.text
      end
    end
  end
end
