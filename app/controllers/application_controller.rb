class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :twitter_user

  private

  def twitter_user
    if session['access_token'] && session['access_token_secret']
      @user ||= twitter_client.user(include_entities: true)
    end
  end

  def twitter_client
    @tclient ||= client = Twitter::REST::Client.new do |config|
      config.consumer_key    = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token = session['access_token']
      config.access_token_secret = session['access_token_secret']
    end
  end
end
