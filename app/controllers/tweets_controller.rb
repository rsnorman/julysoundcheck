class TweetsController < ApplicationController
  before_action :archive_new_tweets, only: :index
  before_action :set_tweets, only: :index

  private

  def archive_new_tweets
    Rails.cache.fetch 'tweet-archiver', expires_in: 5.minutes do
      if Archiver::TweetArchiver.archive.any?
        SheetSync::Downloader.download
      end
    end
  end

  def set_tweets
    @tweets = JulySoundcheckTweets.all.map { |t| JulySoundcheckTweet.new(t) }
  end
end
