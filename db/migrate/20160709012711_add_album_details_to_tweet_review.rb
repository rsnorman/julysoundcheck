class AddAlbumDetailsToTweetReview < ActiveRecord::Migration[5.0]
  def change
    add_column :tweet_reviews, :artist,     :string
    add_column :tweet_reviews, :album,      :string
    add_column :tweet_reviews, :listen_url, :string
  end
end
