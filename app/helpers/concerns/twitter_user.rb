module TwitterUser
  def twitter_user
    if session['access_token'] && session['access_token_secret']
      @twitter_user ||= Rails.cache.fetch(cache_key) do
        twitter_client.user(include_entities: true)
      end
    end
  end

  private

  def cache_key
    "#{session['access_token']}:#{session['access_token_secret']}"
  end

  def twitter_client
    @twitter_client ||= TwitterClient.instance(
      access_token:  session['access_token'],
      access_secret: session['access_token_secret']
    )
  end
end
