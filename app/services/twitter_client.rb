class TwitterClient
  TWITTER_KEY    = ENV['TWITTER_CONSUMER_KEY']
  TWITTER_SECRET = ENV['TWITTER_CONSUMER_SECRET']

  def self.instance(*args)
    new(*args).client
  end

  def initialize(key: TWITTER_KEY,
                 secret: TWITTER_SECRET,
                 access_token: nil,
                 access_secret: nil)
    @key = key
    @secret = secret
    @access_token = access_token
    @access_secret = access_secret
  end

  def client
    @client ||= Twitter::REST::Client.new do |config|
      config.consumer_key    = @key
      config.consumer_secret = @secret
      config.access_token = @access_token
      config.access_token_secret = @access_secret
    end
  end
end
