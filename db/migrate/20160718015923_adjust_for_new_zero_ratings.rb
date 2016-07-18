class AdjustForNewZeroRatings < ActiveRecord::Migration[5.0]
  class MigrateTweetReview < ActiveRecord::Base
    self.table_name = :tweet_reviews
  end

  def up
    MigrateTweetReview.where('rating > 0').each do |tr|
      tr.update(rating: tr.rating + 2)
    end
    MigrateTweetReview.where(rating: 0).update_all(rating: 1)
  end

  def down
    MigrateTweetReview.where('rating > 2').each do |tr|
      tr.update(rating: tr.rating - 2)
    end
    MigrateTweetReview.where(rating: 1).update_all(rating: 0)
  end
end
