class AddAlbumIdToReviewTweet < ActiveRecord::Migration[5.0]
  def change
    add_column :tweet_reviews, :album_source_id, :string
  end
end
