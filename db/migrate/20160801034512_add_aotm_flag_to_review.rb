class AddAotmFlagToReview < ActiveRecord::Migration[5.0]
  def change
    add_column :tweet_reviews, :album_of_the_month, :boolean, default: false
  end
end
