module SheetSync
  class ReviewRowFinder
    attr_reader :worksheet

    def initialize(worksheet)
      @worksheet = worksheet
    end

    def find(tweet_review)
      worksheet.each_row do |row|
        return row if includes_tweet_review?(tweet_review, row)
      end
      nil
    end

    private

    def includes_tweet_review?(tweet_review, row)
      tweet_cell = row.tweet(with_formula: true)
      tweet_link?(tweet_review.tweet, tweet_cell) ||
        tweet_link?(tweet_review.tweet.reply, tweet_cell)
    end

    def tweet_link?(tweet, cell_content)
      return false unless tweet
      cell_content.include?("/status/#{tweet.tweet_id}")
    end
  end
end
