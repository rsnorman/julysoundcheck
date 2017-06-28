class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :recoverable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable
  has_many :tweets
  has_many :tweet_reviews
  has_many :feed_items

  validates :twitter_screen_name, uniqueness: true, if: 'twitter_screen_name.present?'

  before_save :set_slug

  def name
    super() || twitter_name
  end

  private

  def set_slug
    return if name.nil?
    self.slug = name.gsub(/\s/, '_').gsub(/[^\w+]/, '').downcase
  end
end
