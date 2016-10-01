module TwitterUser
  def twitter_user
    if session['access_token'] && session['access_token_secret']
      @twitter_user ||= Rails.cache.fetch("#{session['access_token']}:#{session['access_token_secret']}") do
        twitter_client.user(include_entities: true)
      end
    end
  end

  private

  def twitter_client
    @twitter_client ||= TwitterClient.instance(
      access_token:  session['access_token'],
      access_secret: session['access_token_secret']
    )
  end
end
