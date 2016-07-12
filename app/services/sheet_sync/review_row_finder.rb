module SheetSync
  class ReviewRowFinder
    attr_reader :worksheet

    def initialize(worksheet)
      @worksheet = worksheet
    end

    def find(tweet_review)
      worksheet.each_row do |row|
        return row if row.tweet(with_formula: true).include?("/status/#{tweet_review.tweet_id}")
      end
      nil
    end
  end
end
