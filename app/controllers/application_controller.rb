class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user
  helper_method :twitter_user

  private

  def current_user
    @current_user ||= User.find_by(twitter_id: twitter_user.id)
  end

  def twitter_user
    if session['access_token'] && session['access_token_secret']
      @twitter_user ||= Rails.cache.fetch("#{session['access_token']}:#{session['access_token_secret']}") do
        twitter_client.user(include_entities: true)
      end
    end
  end

  def twitter_client
    @twitter_client ||= TwitterClient.instance(
      access_token:  session['access_token'],
      access_secret: session['access_token_secret']
    )
  end
end
