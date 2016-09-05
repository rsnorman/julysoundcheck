class JulySoundcheckReview
  attr_reader :review, :user, :feed_item

  delegate :profile_image_uri, to: :user
  delegate :name, to: :user, prefix: true
  delegate :rating, :artist, :album, :listen_url, :genre, :album_of_the_month, to: :review
  delegate :description, to: :rating, prefix: true

  def initialize(review, feed_item)
    @review = review
    @user = @review.user
    @feed_item = feed_item
  end

  def text
    review.text || '<em>No review</em>'
  end

  def screen_name
    user.twitter_screen_name || user.slug
  end

  def twitter_account?
    user.twitter_id
  end

  def reviewed_on
    feed_item.created_at.in_time_zone.to_date
  end

  def listen_source
    return if review.listen_url.blank?
    review.listen_source
  end

  def album_id
    review.album_source_id
  end

  def album_of_the_month?
    album_of_the_month
  end
end
