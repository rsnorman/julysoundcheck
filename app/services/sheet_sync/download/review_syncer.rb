module SheetSync
  module Download
    class ReviewSyncer
      def initialize(type: :tweet_review,
                     reviewer_finder: ReviewerFinder.new,
                     feed_item_creator: FeedItemCreator)
        @type = type
        @reviewer_finder = reviewer_finder
        @feed_item_creator = feed_item_creator
      end

      def sync(review_attributes)
        user = user_for(review_attributes[:reviewer])
        review = user_review_for(user, review_attributes)

        if review
          review.update!(review_attributes)
        else
          review = user.tweet_reviews.create!(review_attributes)
          @feed_item_creator.new(review, @type).create
        end
      end

      private

      def user_for(reviewer)
        @reviewer_finder.find(reviewer)
      end

      def user_review_for(user, review_attributes)
        user.tweet_reviews.find_by(artist: review_attributes[:artist],
                                   album: review_attributes[:album])
      end
    end
  end
end
