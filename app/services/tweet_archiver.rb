class TweetArchiver
  def initialize(archived_tweets = Tweet.all)
    @archived_tweets = archived_tweets
  end

  def archive
    client.search('#julysoundcheck', since_id: since_id).each do |tweet|
      Tweet.create(
        tweet_id: tweet.id,
        name: tweet.user.name,
        screen_name: tweet.user.screen_name,
        text: tweet.text,
        tweeted_at: tweet.created_at
      )
    end
  end

  def since_id
    @archived_tweets.order(:tweet_id).first
  end

  def client
    TwitterClient.instance
  end
end
