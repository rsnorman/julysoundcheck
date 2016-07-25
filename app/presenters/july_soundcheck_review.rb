class JulySoundcheckReview
  attr_reader :review, :user, :feed_item

  delegate :profile_image_uri, to: :user
  delegate :rating, :artist, :album, :listen_url, :genre, to: :review
  delegate :description, to: :rating, prefix: true

  def initialize(review, feed_item)
    @review = review
    @user = @review.user
    @feed_item = feed_item
  end

  def text
    review.text || '<em>No review</em>'
  end

  def user_name
    user.name
  end

  def screen_name
    user.name.underscore
  end

  def reviewed_on
    feed_item.created_at.to_date
  end

  def listen_source
    return if review.listen_url.blank?
    review.listen_source
  end

  def album_id
    review.album_source_id
  end
end
